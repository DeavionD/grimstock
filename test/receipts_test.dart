import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grimstock/data/database.dart';
import 'package:grimstock/data/expense_repository.dart';
import 'package:grimstock/data/export.dart';
import 'package:grimstock/data/receipt_parser.dart';
import 'package:grimstock/data/receipt_repository.dart';
import 'package:grimstock/data/sales_repository.dart';
import 'package:grimstock/data/item_repository.dart';

void main() {
  final now = DateTime(2026, 10, 8);

  group('parseReceipt', () {
    test('reads a store receipt', () {
      final parsed = parseReceipt('''
TARGET
Store 1234 Anytown, TX
10/05/2026 14:32
012345678 NIKE DUNK LOW 89.99 T
SHIPPING TAPE 7.99 T
SUBTOTAL 97.98
TAX 8.25% 8.08
TOTAL 106.06
VISA 106.06
CHANGE DUE 0.00
''', now: now);
      expect(parsed.store, 'TARGET');
      expect(parsed.date, DateTime(2026, 10, 5));
      expect(parsed.subtotalCents, 9798);
      expect(parsed.taxCents, 808);
      expect(parsed.totalCents, 10606);
      expect(parsed.lines, [('NIKE DUNK LOW', 8999), ('SHIPPING TAPE', 799)]);
    });

    test('works out the subtotal and reads written dates', () {
      final parsed = parseReceipt('''
Thank you for shopping
Goodwill Outlet
Oct 3, 2026
Vintage jacket \$12.00
Sales Tax \$0.99
Grand Total \$12.99
''', now: now);
      expect(parsed.store, 'Goodwill Outlet');
      expect(parsed.date, DateTime(2026, 10, 3));
      expect(parsed.totalCents, 1299);
      expect(parsed.taxCents, 99);
      expect(parsed.subtotalCents, 1200);
      expect(parsed.lines, [('Vintage jacket', 1200)]);
    });

    test(
      'ignores dates in the future and falls back to the largest amount',
      () {
        final parsed = parseReceipt('''
12/25/2027
Widget 4.00
Gadget 6.50
''', now: now);
        expect(parsed.date, isNull);
        expect(parsed.totalCents, 650);
      },
    );
  });

  group('ReceiptRepository', () {
    late GrimstockDatabase db;
    late ExpenseRepository expenses;
    late ReceiptRepository receipts;

    setUp(() {
      db = GrimstockDatabase(NativeDatabase.memory());
      expenses = ExpenseRepository(db);
      receipts = ReceiptRepository(db, expenses);
    });
    tearDown(() => db.close());

    ReceiptDraft draft({int? id, ReceiptPurpose? purpose}) => ReceiptDraft(
      id: id,
      store: 'Uline',
      purchasedAt: DateTime(2026, 10, 5),
      purpose: purpose ?? ReceiptPurpose.expense,
      subtotalCents: 4000,
      taxCents: 330,
      totalCents: 4330,
      photoPath: '/photos/r1.jpg',
      lines: const [('Shoe boxes', 3000), ('Tape', 1000), ('  ', 5)],
    );

    test('a business receipt is also an expense until switched', () async {
      final id = await receipts.save(draft());
      var list = await expenses.watchExpenses().first;
      expect(list.single.amountCents, 4330);
      expect(list.single.description, 'Uline');

      final details = await receipts.getReceipt(id);
      expect(details!.lines.map((l) => l.description), ['Shoe boxes', 'Tape']);

      await receipts.save(draft(id: id, purpose: ReceiptPurpose.inventory));
      list = await expenses.watchExpenses().first;
      expect(list, isEmpty);
      expect((await receipts.getReceipt(id))!.receipt.expenseId, isNull);
    });

    test(
      'delete removes lines and the expense and returns the photo',
      () async {
        final id = await receipts.save(draft());
        expect(await receipts.delete(id), '/photos/r1.jpg');
        expect(await receipts.getReceipt(id), isNull);
        expect(await db.select(db.receiptLines).get(), isEmpty);
        expect(await expenses.watchExpenses().first, isEmpty);
      },
    );

    test('exports receipts and their items as CSV', () async {
      final id = await receipts.save(draft());
      final exporter = Exporter(
        db,
        SalesRepository(db, ItemRepository(db)),
        expenses,
        receipts,
      );
      final csv = await exporter.receiptsCsv(
        photoNames: {id: 'receipt-2026-10-05-uline-$id.jpg'},
      );
      final rows = csv.trim().split('\n');
      expect(
        rows.first.trim(),
        'Date,Store,Purpose,Items,Subtotal,Tax,Total,Notes,Photo',
      );
      expect(
        rows[1].trim(),
        '2026-10-05,Uline,Business expense,Shoe boxes; Tape,40.00,3.30,'
        '43.30,,receipt-2026-10-05-uline-$id.jpg',
      );

      final items = (await exporter.receiptItemsCsv()).trim().split('\n');
      expect(items.map((r) => r.trim()), [
        'Date,Store,Item,Amount',
        '2026-10-05,Uline,Shoe boxes,30.00',
        '2026-10-05,Uline,Tape,10.00',
      ]);
    });
  });

  test('upgrading from version 2 adds the receipt tables', () async {
    final dir = await Directory.systemTemp.createTemp('grimstock');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/v2.sqlite');

    final v2 = GrimstockDatabase(NativeDatabase(file));
    await v2.customStatement('DROP TABLE receipt_lines');
    await v2.customStatement('DROP TABLE receipts');
    await v2.customStatement('PRAGMA user_version = 2');
    await v2.close();

    final v3 = GrimstockDatabase(NativeDatabase(file));
    addTearDown(v3.close);
    final id = await ReceiptRepository(v3, ExpenseRepository(v3)).save(
      ReceiptDraft(
        store: 'Walmart',
        purchasedAt: DateTime(2026, 10, 1),
        purpose: ReceiptPurpose.inventory,
        totalCents: 999,
      ),
    );
    expect(id, 1);
  });
}
