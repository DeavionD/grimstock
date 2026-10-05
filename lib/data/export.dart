import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

import 'database.dart';
import 'expense_repository.dart';
import 'item_repository.dart';
import 'sales_repository.dart';

/// Turns rows into CSV, quoting values that contain commas, quotes or
/// line breaks.
String toCsv(List<List<Object?>> rows) {
  String cell(Object? value) {
    final text = value?.toString() ?? '';
    if (text.contains(RegExp('[",\r\n]'))) {
      return '"${text.replaceAll('"', '""')}"';
    }
    return text;
  }

  return '${rows.map((row) => row.map(cell).join(',')).join('\r\n')}\r\n';
}

String _money(int cents) => (cents / 100).toStringAsFixed(2);
final _date = DateFormat('yyyy-MM-dd');
String _day(DateTime? date) => date == null ? '' : _date.format(date);

/// Profit and loss for a date range, the numbers a tax preparer asks for.
class ProfitAndLoss {
  const ProfitAndLoss({
    required this.revenueCents,
    required this.costOfGoodsCents,
    required this.platformFeesCents,
    required this.shippingCents,
    required this.packagingCents,
    required this.expensesByKind,
  });

  final int revenueCents;
  final int costOfGoodsCents;
  final int platformFeesCents;
  final int shippingCents;
  final int packagingCents;
  final Map<ExpenseKind, int> expensesByKind;

  int get grossProfitCents =>
      revenueCents -
      costOfGoodsCents -
      platformFeesCents -
      shippingCents -
      packagingCents;

  int get expensesCents => expensesByKind.values.fold(0, (a, b) => a + b);

  int get netProfitCents => grossProfitCents - expensesCents;

  static ProfitAndLoss from(List<Sale> sales, List<Expense> expenses) {
    var revenue = 0, cost = 0, fees = 0, shipping = 0, packaging = 0;
    for (final sale in sales) {
      revenue += sale.salePriceCents;
      cost += sale.totalCostCents;
      fees += sale.platformFeesCents;
      shipping += sale.outboundShippingCents;
      packaging += sale.packagingCents;
    }
    final byKind = <ExpenseKind, int>{};
    for (final expense in expenses) {
      byKind.update(
        expense.expenseKind,
        (total) => total + expense.amountCents,
        ifAbsent: () => expense.amountCents,
      );
    }
    return ProfitAndLoss(
      revenueCents: revenue,
      costOfGoodsCents: cost,
      platformFeesCents: fees,
      shippingCents: shipping,
      packagingCents: packaging,
      expensesByKind: byKind,
    );
  }

  List<List<Object?>> rows(String period) => [
    ['Profit and loss', period],
    [],
    ['Sales revenue', _money(revenueCents)],
    ['Cost of goods sold', _money(-costOfGoodsCents)],
    ['Platform fees', _money(-platformFeesCents)],
    ['Shipping', _money(-shippingCents)],
    ['Packaging', _money(-packagingCents)],
    ['Gross profit', _money(grossProfitCents)],
    [],
    for (final kind in ExpenseKind.values)
      if (expensesByKind[kind] case final cents?)
        ['Expense: ${kind.label}', _money(-cents)],
    ['Total expenses', _money(-expensesCents)],
    [],
    ['Net profit', _money(netProfitCents)],
  ];
}

/// Builds the CSV files for export. [from] and [to] limit sales and
/// expenses to a date range (to is exclusive); inventory is always current.
class Exporter {
  Exporter(this.db, this.sales, this.expenses);

  final GrimstockDatabase db;
  final SalesRepository sales;
  final ExpenseRepository expenses;

  Future<String> inventoryCsv() async {
    final rows = await db.select(db.items).join([
      leftOuterJoin(
        db.categories,
        db.categories.id.equalsExp(db.items.categoryId),
      ),
      leftOuterJoin(
        db.purchaseSources,
        db.purchaseSources.id.equalsExp(db.items.purchaseSourceId),
      ),
    ]).get();
    return toCsv([
      [
        'Name',
        'Brand',
        'Category',
        'Size',
        'Condition',
        'SKU',
        'Quantity',
        'Status',
        'Purchase date',
        'Bought at',
        'Storage',
        'Cost each',
        'Total cost',
      ],
      for (final row in rows)
        if (row.readTable(db.items) case final item)
          [
            item.name,
            item.brand,
            row.readTableOrNull(db.categories)?.name,
            item.sizeVariant,
            item.condition,
            item.sku,
            item.quantity,
            item.status.name,
            _day(item.purchaseDate),
            row.readTableOrNull(db.purchaseSources)?.name,
            item.storageLocation,
            _money(item.unitCostCents),
            _money(item.unitCostCents * item.quantity),
          ],
    ]);
  }

  Future<String> salesCsv({DateTime? from, DateTime? to}) async {
    final entries = (await sales.watchSold().first)
        .where((e) => _inRange(e.sale.soldAt, from, to))
        .toList()
        .reversed;
    return toCsv([
      [
        'Sold date',
        'Item',
        'Brand',
        'SKU',
        'Quantity',
        'Bought at',
        'Sold on',
        'Sale price',
        'Platform fees',
        'Shipping',
        'Packaging',
        'Cost',
        'Profit',
        'Tracking',
        'Shipped date',
      ],
      for (final e in entries)
        [
          _day(e.sale.soldAt),
          e.item.name,
          e.item.brand,
          e.item.sku,
          e.sale.quantity,
          e.purchaseSource?.name,
          e.platform?.name,
          _money(e.sale.salePriceCents),
          _money(e.sale.platformFeesCents),
          _money(e.sale.outboundShippingCents),
          _money(e.sale.packagingCents),
          _money(e.sale.totalCostCents),
          _money(e.sale.profitCents),
          e.sale.trackingNumber,
          _day(e.sale.shippedAt),
        ],
    ]);
  }

  Future<String> expensesCsv({DateTime? from, DateTime? to}) async {
    final list = await expenses.watchExpenses(from: from, to: to).first;
    return toCsv([
      ['Date', 'Kind', 'Description', 'Miles', 'Amount'],
      for (final e in list.reversed)
        [
          _day(e.spentAt),
          e.expenseKind.label,
          e.description,
          e.miles,
          _money(e.amountCents),
        ],
    ]);
  }

  Future<ProfitAndLoss> profitAndLoss({DateTime? from, DateTime? to}) async {
    final soldEntries = await sales.watchSold().first;
    return ProfitAndLoss.from([
      for (final e in soldEntries)
        if (_inRange(e.sale.soldAt, from, to)) e.sale,
    ], await expenses.watchExpenses(from: from, to: to).first);
  }

  Future<String> profitAndLossCsv({
    DateTime? from,
    DateTime? to,
    required String periodLabel,
  }) async =>
      toCsv((await profitAndLoss(from: from, to: to)).rows(periodLabel));

  static bool _inRange(DateTime date, DateTime? from, DateTime? to) =>
      (from == null || !date.isBefore(from)) &&
      (to == null || date.isBefore(to));
}
