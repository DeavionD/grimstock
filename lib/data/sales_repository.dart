import 'package:drift/drift.dart';

import '../core/money.dart';
import 'database.dart';
import 'item_repository.dart';

/// Thrown when a sale asks for more units than the item has left.
class NotEnoughQuantity implements Exception {
  const NotEnoughQuantity(this.available);

  final int available;
}

/// What the "Mark as sold" form saves. Amounts are totals for the sale.
class SaleDraft {
  const SaleDraft({
    required this.itemId,
    required this.salePriceCents,
    required this.soldAt,
    this.quantity = 1,
    this.platformId,
    this.platformFeesCents = 0,
    this.outboundShippingCents = 0,
    this.packagingCents = 0,
    this.trackingNumber,
  });

  final int itemId;
  final int quantity;
  final int? platformId;
  final DateTime soldAt;
  final int salePriceCents;
  final int platformFeesCents;
  final int outboundShippingCents;
  final int packagingCents;
  final String? trackingNumber;
}

extension SaleMath on Sale {
  int get totalCostCents => unitCostCents * quantity;

  int get profitCents =>
      salePriceCents -
      platformFeesCents -
      outboundShippingCents -
      packagingCents -
      totalCostCents;

  double? get marginPercent =>
      salePriceCents == 0 ? null : profitCents / salePriceCents * 100;

  double? get roiPercent =>
      totalCostCents == 0 ? null : profitCents / totalCostCents * 100;
}

/// A sale as shown in the Sold archive, with what was sold, where it was
/// bought and where it sold.
class SoldEntry {
  const SoldEntry({
    required this.sale,
    required this.item,
    this.platform,
    this.purchaseSource,
  });

  final Sale sale;
  final Item item;
  final Platform? platform;
  final PurchaseSource? purchaseSource;

  /// Days from purchase (or adding the item) to the sale.
  int get daysToSell =>
      sale.soldAt.difference(item.purchaseDate ?? item.createdAt).inDays;
}

class SalesSummary {
  const SalesSummary({
    this.sales = 0,
    this.units = 0,
    this.revenueCents = 0,
    this.profitCents = 0,
  });

  final int sales;
  final int units;
  final int revenueCents;
  final int profitCents;
}

class SalesRepository {
  SalesRepository(this.db, this.items);

  final GrimstockDatabase db;
  final ItemRepository items;

  /// Records a sale. Selling every remaining unit marks the item Sold;
  /// selling some of them lowers the item's quantity. Returns the sale id.
  Future<int> recordSale(SaleDraft draft) {
    return db.transaction(() async {
      final item = await (db.select(
        db.items,
      )..where((i) => i.id.equals(draft.itemId))).getSingle();
      if (!item.isActive) throw const NotEnoughQuantity(0);
      final quantity = draft.quantity < 1 ? 1 : draft.quantity;
      if (quantity > item.quantity) throw NotEnoughQuantity(item.quantity);

      final tracking = draft.trackingNumber?.trim() ?? '';
      final saleId = await db
          .into(db.sales)
          .insert(
            SalesCompanion.insert(
              itemId: item.id,
              platformId: Value(draft.platformId),
              soldAt: draft.soldAt,
              quantity: Value(quantity),
              unitCostCents: Value(item.unitCostCents),
              salePriceCents: draft.salePriceCents,
              platformFeesCents: Value(draft.platformFeesCents),
              outboundShippingCents: Value(draft.outboundShippingCents),
              packagingCents: Value(draft.packagingCents),
              trackingNumber: Value(tracking.isEmpty ? null : tracking),
            ),
          );

      final soldOut = quantity == item.quantity;
      await (db.update(db.items)..where((i) => i.id.equals(item.id))).write(
        ItemsCompanion(
          status: soldOut ? const Value(ItemStatus.sold) : const Value.absent(),
          quantity: soldOut
              ? const Value.absent()
              : Value(item.quantity - quantity),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return saleId;
    });
  }

  /// Saves a tracking number and marks the sale shipped. When the item has
  /// sold out, its status moves to Shipped too.
  Future<void> markShipped(int saleId, {String? trackingNumber}) {
    return db.transaction(() async {
      final sale = await (db.select(
        db.sales,
      )..where((s) => s.id.equals(saleId))).getSingle();
      final tracking = trackingNumber?.trim() ?? '';
      await (db.update(db.sales)..where((s) => s.id.equals(saleId))).write(
        SalesCompanion(
          shippedAt: Value(DateTime.now()),
          trackingNumber: tracking.isEmpty
              ? const Value.absent()
              : Value(tracking),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await (db.update(db.items)..where(
            (i) =>
                i.id.equals(sale.itemId) &
                i.status.equalsValue(ItemStatus.sold),
          ))
          .write(const ItemsCompanion(status: Value(ItemStatus.shipped)));
    });
  }

  /// Deletes a sale recorded by mistake and puts its units back in stock.
  Future<void> undoSale(int saleId) {
    return db.transaction(() async {
      final sale = await (db.select(
        db.sales,
      )..where((s) => s.id.equals(saleId))).getSingle();
      final item = await (db.select(
        db.items,
      )..where((i) => i.id.equals(sale.itemId))).getSingle();

      if (item.isActive) {
        await (db.update(db.items)..where((i) => i.id.equals(item.id))).write(
          ItemsCompanion(
            quantity: Value(item.quantity + sale.quantity),
            updatedAt: Value(DateTime.now()),
          ),
        );
      } else {
        await items.checkActiveLimit();
        await (db.update(db.items)..where((i) => i.id.equals(item.id))).write(
          ItemsCompanion(
            status: const Value(ItemStatus.inStock),
            quantity: Value(sale.quantity),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
      await (db.delete(db.sales)..where((s) => s.id.equals(saleId))).go();
    });
  }

  JoinedSelectStatement<HasResultSet, dynamic> _soldQuery() {
    return db.select(db.sales).join([
      innerJoin(db.items, db.items.id.equalsExp(db.sales.itemId)),
      leftOuterJoin(
        db.platforms,
        db.platforms.id.equalsExp(db.sales.platformId),
      ),
      leftOuterJoin(
        db.purchaseSources,
        db.purchaseSources.id.equalsExp(db.items.purchaseSourceId),
      ),
    ]);
  }

  SoldEntry _toEntry(TypedResult row) => SoldEntry(
    sale: row.readTable(db.sales),
    item: row.readTable(db.items),
    platform: row.readTableOrNull(db.platforms),
    purchaseSource: row.readTableOrNull(db.purchaseSources),
  );

  /// The Sold archive, newest sale first.
  Stream<List<SoldEntry>> watchSold({String query = '', int? platformId}) {
    final q = _soldQuery();
    final text = query.trim();
    if (text.isNotEmpty) {
      final pattern = '%$text%';
      q.where(
        db.items.name.like(pattern) |
            db.items.brand.like(pattern) |
            db.items.sku.like(pattern),
      );
    }
    if (platformId != null) q.where(db.sales.platformId.equals(platformId));
    q.orderBy([
      OrderingTerm.desc(db.sales.soldAt),
      OrderingTerm.desc(db.sales.id),
    ]);
    return q.watch().map((rows) => rows.map(_toEntry).toList());
  }

  Stream<SoldEntry?> watchSale(int saleId) {
    final q = _soldQuery()..where(db.sales.id.equals(saleId));
    return q.watchSingleOrNull().map(
      (row) => row == null ? null : _toEntry(row),
    );
  }

  Stream<List<Sale>> watchSalesForItem(int itemId) =>
      (db.select(db.sales)
            ..where((s) => s.itemId.equals(itemId))
            ..orderBy([(s) => OrderingTerm.desc(s.soldAt)]))
          .watch();

  /// Totals for sales between [from] (inclusive) and [to] (exclusive).
  Stream<SalesSummary> watchSummary({DateTime? from, DateTime? to}) {
    final query = db.select(db.sales);
    if (from != null) query.where((s) => s.soldAt.isBiggerOrEqualValue(from));
    if (to != null) query.where((s) => s.soldAt.isSmallerThanValue(to));
    return query.watch().map((sales) {
      var units = 0, revenue = 0, profit = 0;
      for (final sale in sales) {
        units += sale.quantity;
        revenue += sale.salePriceCents;
        profit += sale.profitCents;
      }
      return SalesSummary(
        sales: sales.length,
        units: units,
        revenueCents: revenue,
        profitCents: profit,
      );
    });
  }
}

/// Suggested fees for a sale of [salePriceCents] spread over [quantity]
/// units on [platform]. Per-order fees apply to each unit, since
/// multi-unit sales are usually separate orders.
int suggestedFees(FeeRule? rule, int salePriceCents, int quantity) {
  if (rule == null || quantity < 1) return 0;
  final unitPrice = (salePriceCents / quantity).round();
  return rule.feesFor(unitPrice) * quantity;
}
