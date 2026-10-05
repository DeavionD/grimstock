import 'package:drift/drift.dart';

import 'database.dart';

/// Thrown when a free user tries to go past the active item limit.
class FreeLimitReached implements Exception {
  const FreeLimitReached(this.limit);

  final int limit;
}

/// Thrown when deleting an item that already has sales. Sold items stay in
/// the Sold archive, so they can't be deleted.
class ItemHasSales implements Exception {
  const ItemHasSales();
}

enum ItemSort { newest, oldest, costHighToLow, nameAToZ }

/// An item as it appears in the inventory list.
class ItemListEntry {
  const ItemListEntry({required this.item, this.categoryName});

  final Item item;
  final String? categoryName;
}

/// Everything shown on an item's detail screen.
class ItemDetails {
  const ItemDetails({
    required this.item,
    this.category,
    this.purchaseSource,
    this.fields = const [],
  });

  final Item item;
  final Category? category;
  final PurchaseSource? purchaseSource;

  /// The category's custom fields paired with this item's value (if any).
  final List<(CategoryField, String?)> fields;
}

/// The values the add/edit form saves. [id] is null for a new item.
class ItemDraft {
  const ItemDraft({
    this.id,
    required this.name,
    this.categoryId,
    this.brand,
    this.sizeVariant,
    this.condition,
    this.sku,
    this.quantity = 1,
    this.status = ItemStatus.inStock,
    this.purchaseDate,
    this.purchaseSourceName,
    this.storageLocation,
    this.notes,
    this.purchasePriceCents = 0,
    this.purchaseTaxCents = 0,
    this.inboundShippingCents = 0,
    this.otherCostsCents = 0,
    this.fieldValues = const {},
  });

  final int? id;
  final String name;
  final int? categoryId;
  final String? brand;
  final String? sizeVariant;
  final String? condition;
  final String? sku;
  final int quantity;
  final ItemStatus status;
  final DateTime? purchaseDate;
  final String? purchaseSourceName;
  final String? storageLocation;
  final String? notes;
  final int purchasePriceCents;
  final int purchaseTaxCents;
  final int inboundShippingCents;
  final int otherCostsCents;

  /// Custom field id → value.
  final Map<int, String> fieldValues;
}

extension ItemMath on Item {
  /// What one unit cost to buy and get in hand.
  int get unitCostCents =>
      purchasePriceCents +
      purchaseTaxCents +
      inboundShippingCents +
      otherCostsCents;

  int daysInStock(DateTime now) =>
      now.difference(purchaseDate ?? createdAt).inDays;

  bool get isActive => activeStatuses.contains(status);
}

class ItemRepository {
  ItemRepository(this.db, {this.activeItemLimit});

  final GrimstockDatabase db;

  /// Null means no limit (Pro).
  final int? activeItemLimit;

  Stream<List<ItemListEntry>> watchItems({
    String query = '',
    ItemStatus? status,
    ItemSort sort = ItemSort.newest,
  }) {
    final items = db.items;
    final joined = db.select(items).join([
      leftOuterJoin(
        db.categories,
        db.categories.id.equalsExp(items.categoryId),
      ),
    ]);

    final text = query.trim();
    if (text.isNotEmpty) {
      final pattern = '%$text%';
      joined.where(
        items.name.like(pattern) |
            items.brand.like(pattern) |
            items.sku.like(pattern) |
            items.sizeVariant.like(pattern),
      );
    }
    if (status != null) joined.where(items.status.equalsValue(status));

    final cost =
        items.purchasePriceCents +
        items.purchaseTaxCents +
        items.inboundShippingCents +
        items.otherCostsCents;
    joined.orderBy([
      switch (sort) {
        ItemSort.newest => OrderingTerm.desc(items.createdAt),
        ItemSort.oldest => OrderingTerm.asc(items.createdAt),
        ItemSort.costHighToLow => OrderingTerm.desc(cost),
        ItemSort.nameAToZ => OrderingTerm.asc(
          items.name.collate(Collate.noCase),
        ),
      },
      OrderingTerm.desc(items.id),
    ]);

    return joined.watch().map(
      (rows) => [
        for (final row in rows)
          ItemListEntry(
            item: row.readTable(items),
            categoryName: row.readTableOrNull(db.categories)?.name,
          ),
      ],
    );
  }

  Stream<ItemDetails?> watchItem(int id) {
    return (db.select(db.items)..where((i) => i.id.equals(id)))
        .watchSingleOrNull()
        .asyncMap((item) async {
          if (item == null) return null;
          final category = item.categoryId == null
              ? null
              : await (db.select(db.categories)
                      ..where((c) => c.id.equals(item.categoryId!)))
                    .getSingleOrNull();
          final source = item.purchaseSourceId == null
              ? null
              : await (db.select(db.purchaseSources)
                      ..where((s) => s.id.equals(item.purchaseSourceId!)))
                    .getSingleOrNull();
          final fields = item.categoryId == null
              ? const <CategoryField>[]
              : await getCategoryFields(item.categoryId!);
          final values = {
            for (final v in await (db.select(
              db.itemFieldValues,
            )..where((v) => v.itemId.equals(id))).get())
              v.fieldId: v.value,
          };
          return ItemDetails(
            item: item,
            category: category,
            purchaseSource: source,
            fields: [for (final f in fields) (f, values[f.id])],
          );
        });
  }

  Future<List<CategoryField>> getCategoryFields(int categoryId) =>
      (db.select(db.categoryFields)
            ..where((f) => f.categoryId.equals(categoryId))
            ..orderBy([(f) => OrderingTerm.asc(f.sortOrder)]))
          .get();

  Stream<List<PurchaseSource>> watchPurchaseSources() =>
      (db.select(
            db.purchaseSources,
          )..orderBy([(s) => OrderingTerm.asc(s.name.collate(Collate.noCase))]))
          .watch();

  /// Total cost of everything still in stock (unit cost × quantity).
  Stream<int> watchMoneyInStock() {
    final items = db.items;
    final total =
        ((items.purchasePriceCents +
                    items.purchaseTaxCents +
                    items.inboundShippingCents +
                    items.otherCostsCents) *
                items.quantity)
            .sum();
    final query = db.selectOnly(items)
      ..addColumns([total])
      ..where(items.status.isInValues(activeStatuses));
    return query.map((row) => row.read(total) ?? 0).watchSingle();
  }

  Future<int> _activeItemCount() async {
    final count = db.items.id.count();
    final query = db.selectOnly(db.items)
      ..addColumns([count])
      ..where(db.items.status.isInValues(activeStatuses));
    return await query.map((row) => row.read(count) ?? 0).getSingle();
  }

  Future<void> _checkLimit() async {
    final limit = activeItemLimit;
    if (limit != null && await _activeItemCount() >= limit) {
      throw FreeLimitReached(limit);
    }
  }

  Future<int?> _sourceIdFor(String? name) async {
    final trimmed = name?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    final existing =
        await (db.select(db.purchaseSources)
              ..where((s) => s.name.collate(Collate.noCase).equals(trimmed)))
            .getSingleOrNull();
    if (existing != null) return existing.id;
    return db
        .into(db.purchaseSources)
        .insert(PurchaseSourcesCompanion.insert(name: trimmed));
  }

  /// Inserts or updates an item and its custom field values.
  /// Returns the item's id.
  Future<int> saveItem(ItemDraft draft) {
    return db.transaction(() async {
      final existing = draft.id == null
          ? null
          : await (db.select(
              db.items,
            )..where((i) => i.id.equals(draft.id!))).getSingle();
      final becomesActive =
          activeStatuses.contains(draft.status) &&
          (existing == null || !existing.isActive);
      if (becomesActive) await _checkLimit();

      String? clean(String? value) {
        final trimmed = value?.trim() ?? '';
        return trimmed.isEmpty ? null : trimmed;
      }

      final companion = ItemsCompanion(
        name: Value(draft.name.trim()),
        categoryId: Value(draft.categoryId),
        brand: Value(clean(draft.brand)),
        sizeVariant: Value(clean(draft.sizeVariant)),
        condition: Value(clean(draft.condition)),
        sku: Value(clean(draft.sku)),
        quantity: Value(draft.quantity < 1 ? 1 : draft.quantity),
        status: Value(draft.status),
        purchaseDate: Value(draft.purchaseDate),
        purchaseSourceId: Value(await _sourceIdFor(draft.purchaseSourceName)),
        storageLocation: Value(clean(draft.storageLocation)),
        notes: Value(clean(draft.notes)),
        purchasePriceCents: Value(draft.purchasePriceCents),
        purchaseTaxCents: Value(draft.purchaseTaxCents),
        inboundShippingCents: Value(draft.inboundShippingCents),
        otherCostsCents: Value(draft.otherCostsCents),
        updatedAt: Value(DateTime.now()),
      );

      final id = existing == null
          ? await db.into(db.items).insert(companion)
          : existing.id;
      if (existing != null) {
        await (db.update(
          db.items,
        )..where((i) => i.id.equals(id))).write(companion);
      }

      await (db.delete(
        db.itemFieldValues,
      )..where((v) => v.itemId.equals(id))).go();
      for (final entry in draft.fieldValues.entries) {
        final value = entry.value.trim();
        if (value.isEmpty) continue;
        await db
            .into(db.itemFieldValues)
            .insert(
              ItemFieldValuesCompanion.insert(
                itemId: id,
                fieldId: entry.key,
                value: value,
              ),
            );
      }
      return id;
    });
  }

  Future<void> updateStatus(int id, ItemStatus status) {
    return db.transaction(() async {
      final item = await (db.select(
        db.items,
      )..where((i) => i.id.equals(id))).getSingle();
      if (!item.isActive && activeStatuses.contains(status)) {
        await _checkLimit();
      }
      await (db.update(db.items)..where((i) => i.id.equals(id))).write(
        ItemsCompanion(status: Value(status), updatedAt: Value(DateTime.now())),
      );
    });
  }

  /// Copies an item (and its custom fields) as a new in-stock item.
  /// Handy when buying several pairs of the same release.
  Future<int> duplicateItem(int id) {
    return db.transaction(() async {
      await _checkLimit();
      final item = await (db.select(
        db.items,
      )..where((i) => i.id.equals(id))).getSingle();
      final copy = item
          .toCompanion(false)
          .copyWith(
            id: const Value.absent(),
            syncId: const Value.absent(),
            createdAt: const Value.absent(),
            updatedAt: const Value.absent(),
            status: const Value(ItemStatus.inStock),
          );
      final newId = await db.into(db.items).insert(copy);
      final values = await (db.select(
        db.itemFieldValues,
      )..where((v) => v.itemId.equals(id))).get();
      for (final v in values) {
        await db
            .into(db.itemFieldValues)
            .insert(
              ItemFieldValuesCompanion.insert(
                itemId: newId,
                fieldId: v.fieldId,
                value: v.value,
              ),
            );
      }
      return newId;
    });
  }

  Future<void> deleteItem(int id) {
    return db.transaction(() async {
      final sales = await (db.select(
        db.sales,
      )..where((s) => s.itemId.equals(id))).get();
      if (sales.isNotEmpty) throw const ItemHasSales();
      await (db.delete(
        db.itemFieldValues,
      )..where((v) => v.itemId.equals(id))).go();
      await (db.delete(db.itemPhotos)..where((p) => p.itemId.equals(id))).go();
      await (db.delete(db.items)..where((i) => i.id.equals(id))).go();
    });
  }
}
