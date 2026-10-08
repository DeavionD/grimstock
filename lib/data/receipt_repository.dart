import 'package:drift/drift.dart';

import 'database.dart';
import 'expense_repository.dart';

/// Why a receipt was kept.
enum ReceiptPurpose {
  inventory('Stock to resell'),
  expense('Business expense');

  const ReceiptPurpose(this.label);

  final String label;

  static ReceiptPurpose parse(String name) =>
      values.where((p) => p.name == name).firstOrNull ?? inventory;
}

extension ReceiptInfo on Receipt {
  ReceiptPurpose get receiptPurpose => ReceiptPurpose.parse(purpose);
}

class ReceiptDraft {
  const ReceiptDraft({
    this.id,
    required this.store,
    required this.purchasedAt,
    required this.purpose,
    required this.totalCents,
    this.subtotalCents,
    this.taxCents = 0,
    this.photoPath,
    this.scannedText,
    this.notes,
    this.lines = const [],
  });

  final int? id;
  final String store;
  final DateTime purchasedAt;
  final ReceiptPurpose purpose;
  final int totalCents;
  final int? subtotalCents;
  final int taxCents;
  final String? photoPath;
  final String? scannedText;
  final String? notes;
  final List<(String, int)> lines;
}

class ReceiptDetails {
  const ReceiptDetails(this.receipt, this.lines);

  final Receipt receipt;
  final List<ReceiptLine> lines;
}

class ReceiptRepository {
  ReceiptRepository(this.db, this.expenses);

  final GrimstockDatabase db;
  final ExpenseRepository expenses;

  /// Saves a receipt and its line items. A business-expense receipt keeps a
  /// matching expense so it comes out of profit; switching it to stock
  /// removes that expense again.
  Future<int> save(ReceiptDraft draft) => db.transaction(() async {
    final existing = draft.id == null
        ? null
        : await (db.select(
            db.receipts,
          )..where((r) => r.id.equals(draft.id!))).getSingle();

    int? expenseId = existing?.expenseId;
    final store = draft.store.trim();
    if (draft.purpose == ReceiptPurpose.expense) {
      expenseId = await expenses.save(
        ExpenseDraft(
          id: expenseId,
          description: store.isEmpty ? 'Receipt' : store,
          kind: ExpenseKind.supplies,
          spentAt: draft.purchasedAt,
          amountCents: draft.totalCents,
        ),
      );
    }
    // Switched to stock: drop the expense once nothing points at it.
    final staleExpense = draft.purpose == ReceiptPurpose.expense
        ? null
        : expenseId;
    if (staleExpense != null) expenseId = null;

    final companion = ReceiptsCompanion(
      store: Value(store),
      purchasedAt: Value(draft.purchasedAt),
      purpose: Value(draft.purpose.name),
      subtotalCents: Value(draft.subtotalCents),
      taxCents: Value(draft.taxCents),
      totalCents: Value(draft.totalCents),
      photoPath: Value(draft.photoPath),
      scannedText: Value(draft.scannedText),
      notes: Value(_blankToNull(draft.notes)),
      expenseId: Value(expenseId),
      updatedAt: Value(DateTime.now()),
    );
    final id = draft.id ?? await db.into(db.receipts).insert(companion);
    if (draft.id != null) {
      await (db.update(
        db.receipts,
      )..where((r) => r.id.equals(id))).write(companion);
      await (db.delete(
        db.receiptLines,
      )..where((l) => l.receiptId.equals(id))).go();
    }
    if (staleExpense != null) await expenses.delete(staleExpense);
    for (final (i, (description, amount)) in draft.lines.indexed) {
      if (description.trim().isEmpty) continue;
      await db
          .into(db.receiptLines)
          .insert(
            ReceiptLinesCompanion.insert(
              receiptId: id,
              description: description.trim(),
              amountCents: amount,
              sortOrder: Value(i),
            ),
          );
    }
    return id;
  });

  /// Deletes the receipt, its lines and its expense. Returns the photo path
  /// so the caller can remove the file.
  Future<String?> delete(int id) => db.transaction(() async {
    final receipt = await (db.select(
      db.receipts,
    )..where((r) => r.id.equals(id))).getSingleOrNull();
    if (receipt == null) return null;
    await (db.delete(
      db.receiptLines,
    )..where((l) => l.receiptId.equals(id))).go();
    await (db.delete(db.receipts)..where((r) => r.id.equals(id))).go();
    if (receipt.expenseId != null) await expenses.delete(receipt.expenseId!);
    return receipt.photoPath;
  });

  /// Receipts between [from] (inclusive) and [to] (exclusive), newest first.
  Stream<List<Receipt>> watchReceipts({DateTime? from, DateTime? to}) {
    final query = db.select(db.receipts);
    if (from != null) {
      query.where((r) => r.purchasedAt.isBiggerOrEqualValue(from));
    }
    if (to != null) query.where((r) => r.purchasedAt.isSmallerThanValue(to));
    query.orderBy([
      (r) => OrderingTerm.desc(r.purchasedAt),
      (r) => OrderingTerm.desc(r.id),
    ]);
    return query.watch();
  }

  Future<ReceiptDetails?> getReceipt(int id) async {
    final receipt = await (db.select(
      db.receipts,
    )..where((r) => r.id.equals(id))).getSingleOrNull();
    if (receipt == null) return null;
    return ReceiptDetails(receipt, await linesFor([id]));
  }

  Future<List<ReceiptLine>> linesFor(List<int> receiptIds) =>
      (db.select(db.receiptLines)
            ..where((l) => l.receiptId.isIn(receiptIds))
            ..orderBy([
              (l) => OrderingTerm(expression: l.receiptId),
              (l) => OrderingTerm(expression: l.sortOrder),
            ]))
          .get();
}

String? _blankToNull(String? value) =>
    value == null || value.trim().isEmpty ? null : value.trim();
