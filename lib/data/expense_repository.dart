import 'package:drift/drift.dart';

import 'database.dart';

/// Kinds of business expenses that aren't tied to one item.
enum ExpenseKind {
  supplies('Supplies'),
  shipping('Shipping supplies'),
  subscription('Subscription'),
  cookGroup('Cook group'),
  bots('Bots and proxies'),
  mileage('Mileage'),
  other('Other');

  const ExpenseKind(this.label);

  final String label;

  static ExpenseKind parse(String name) =>
      values.where((k) => k.name == name).firstOrNull ?? other;
}

/// The IRS 2026 business standard mileage rate: 72.5 cents per mile.
const defaultMileageRateCents = 72.5;
const mileageRateSettingKey = 'mileage_rate_cents';

/// What the expense form saves. For mileage, [amountCents] is worked out
/// from [miles] and the mileage rate.
class ExpenseDraft {
  const ExpenseDraft({
    this.id,
    required this.description,
    required this.kind,
    required this.spentAt,
    this.amountCents = 0,
    this.miles,
  });

  final int? id;
  final String description;
  final ExpenseKind kind;
  final DateTime spentAt;
  final int amountCents;
  final double? miles;
}

extension ExpenseInfo on Expense {
  ExpenseKind get expenseKind => ExpenseKind.parse(kind);
}

class ExpenseRepository {
  ExpenseRepository(this.db);

  final GrimstockDatabase db;

  Stream<double> watchMileageRate() => db
      .watchSetting(mileageRateSettingKey)
      .map((v) => double.tryParse(v ?? '') ?? defaultMileageRateCents);

  Future<void> setMileageRate(double centsPerMile) =>
      db.setSetting(mileageRateSettingKey, '$centsPerMile');

  /// Saves a new expense or updates one. Mileage is priced at the current
  /// rate when saved, so changing the rate later doesn't rewrite the past.
  Future<int> save(ExpenseDraft draft) async {
    var amount = draft.amountCents;
    if (draft.kind == ExpenseKind.mileage && draft.miles != null) {
      final rate =
          double.tryParse(await db.getSetting(mileageRateSettingKey) ?? '') ??
          defaultMileageRateCents;
      amount = (draft.miles! * rate).round();
    }
    final companion = ExpensesCompanion(
      description: Value(draft.description.trim()),
      kind: Value(draft.kind.name),
      spentAt: Value(draft.spentAt),
      amountCents: Value(amount),
      miles: Value(draft.kind == ExpenseKind.mileage ? draft.miles : null),
      updatedAt: Value(DateTime.now()),
    );
    if (draft.id == null) return db.into(db.expenses).insert(companion);
    await (db.update(
      db.expenses,
    )..where((e) => e.id.equals(draft.id!))).write(companion);
    return draft.id!;
  }

  /// Deletes an expense. A receipt saved as this expense stays, kept as a
  /// stock receipt.
  Future<void> delete(int id) => db.transaction(() async {
    await (db.update(db.receipts)..where((r) => r.expenseId.equals(id))).write(
      const ReceiptsCompanion(
        expenseId: Value(null),
        purpose: Value('inventory'),
      ),
    );
    await (db.delete(db.expenses)..where((e) => e.id.equals(id))).go();
  });

  Stream<Expense?> watchExpense(int id) => (db.select(
    db.expenses,
  )..where((e) => e.id.equals(id))).watchSingleOrNull();

  /// Expenses between [from] (inclusive) and [to] (exclusive), newest first.
  Stream<List<Expense>> watchExpenses({DateTime? from, DateTime? to}) {
    final query = db.select(db.expenses);
    if (from != null) query.where((e) => e.spentAt.isBiggerOrEqualValue(from));
    if (to != null) query.where((e) => e.spentAt.isSmallerThanValue(to));
    query.orderBy([
      (e) => OrderingTerm.desc(e.spentAt),
      (e) => OrderingTerm.desc(e.id),
    ]);
    return query.watch();
  }

  Stream<int> watchTotal({DateTime? from, DateTime? to}) => watchExpenses(
    from: from,
    to: to,
  ).map((expenses) => expenses.fold(0, (sum, e) => sum + e.amountCents));
}
