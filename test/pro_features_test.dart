import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grimstock/data/database.dart';
import 'package:grimstock/data/expense_repository.dart';
import 'package:grimstock/data/export.dart';
import 'package:grimstock/data/item_repository.dart';
import 'package:grimstock/data/pro.dart';
import 'package:grimstock/data/providers.dart';
import 'package:grimstock/data/receipt_repository.dart';
import 'package:grimstock/data/sales_repository.dart';
import 'package:grimstock/data/upc_lookup.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late GrimstockDatabase db;

  setUp(() => db = GrimstockDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('Pro plan', () {
    test('free allows 1 photo and 25 items; Pro lifts both', () async {
      final container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db)],
      );
      addTearDown(container.dispose);
      final sub = container.listen(isProProvider, (_, _) {});
      addTearDown(sub.close);

      var repo = container.read(itemRepositoryProvider);
      expect(repo.photoLimit, FreeLimits.photosPerItem);
      expect(repo.activeItemLimit, FreeLimits.activeItems);
      final id = await repo.saveItem(const ItemDraft(name: 'Shoe'));
      await repo.addPhoto(id, '/a.jpg');
      await expectLater(repo.addPhoto(id, '/b.jpg'), throwsStateError);

      await db.setSetting(devProSettingKey, 'true');
      await container.pump();
      await Future<void>.delayed(Duration.zero);
      expect(container.read(isProProvider), isTrue);
      repo = container.read(itemRepositoryProvider);
      expect(repo.activeItemLimit, isNull);
      await repo.addPhoto(id, '/b.jpg');
      expect(await repo.watchPhotos(id).first, hasLength(2));
    });
  });

  group('expenses', () {
    test('mileage is priced at the rate when saved', () async {
      final repo = ExpenseRepository(db);
      expect(await repo.watchMileageRate().first, 72.5);

      final id = await repo.save(
        ExpenseDraft(
          description: 'Outlet run',
          kind: ExpenseKind.mileage,
          spentAt: DateTime(2026, 10, 1),
          miles: 40,
        ),
      );
      expect((await repo.watchExpense(id).first)!.amountCents, 2900);

      // A new rate applies to new trips, not old ones.
      await repo.setMileageRate(80);
      await repo.save(
        ExpenseDraft(
          description: '',
          kind: ExpenseKind.mileage,
          spentAt: DateTime(2026, 10, 2),
          miles: 10,
        ),
      );
      await repo.save(
        ExpenseDraft(
          description: 'Shoe boxes',
          kind: ExpenseKind.supplies,
          spentAt: DateTime(2026, 9, 15),
          amountCents: 2499,
        ),
      );

      expect(
        await repo
            .watchTotal(from: DateTime(2026, 10), to: DateTime(2026, 11))
            .first,
        2900 + 800,
      );
      expect(await repo.watchTotal().first, 2900 + 800 + 2499);
    });

    test('editing and deleting', () async {
      final repo = ExpenseRepository(db);
      final id = await repo.save(
        ExpenseDraft(
          description: 'Cook group',
          kind: ExpenseKind.cookGroup,
          spentAt: DateTime(2026, 10, 1),
          amountCents: 3000,
        ),
      );
      await repo.save(
        ExpenseDraft(
          id: id,
          description: 'Cook group (annual)',
          kind: ExpenseKind.subscription,
          spentAt: DateTime(2026, 10, 1),
          amountCents: 25000,
        ),
      );
      final saved = (await repo.watchExpense(id).first)!;
      expect(saved.description, 'Cook group (annual)');
      expect(saved.expenseKind, ExpenseKind.subscription);
      await repo.delete(id);
      expect(await repo.watchExpenses().first, isEmpty);
    });
  });

  group('export', () {
    test('quotes CSV values that need it', () {
      expect(
        toCsv([
          ['a', 'b,c', 'say "hi"', null, 3],
        ]),
        'a,"b,c","say ""hi""",,3\r\n',
      );
    });

    test('profit and loss and sales CSV for a year', () async {
      final items = ItemRepository(db);
      final sales = SalesRepository(db, items);
      final expenses = ExpenseRepository(db);
      final exporter = Exporter(
        db,
        sales,
        expenses,
        ReceiptRepository(db, expenses),
      );

      final id = await items.saveItem(
        const ItemDraft(
          name: 'Jordan 4, Bred',
          purchasePriceCents: 20000,
          purchaseSourceName: 'Nike SNKRS',
        ),
      );
      await sales.recordSale(
        SaleDraft(
          itemId: id,
          soldAt: DateTime(2026, 3, 1),
          salePriceCents: 30000,
          platformFeesCents: 4000,
          outboundShippingCents: 1500,
          packagingCents: 200,
        ),
      );
      final old = await items.saveItem(const ItemDraft(name: 'Old sale'));
      await sales.recordSale(
        SaleDraft(
          itemId: old,
          soldAt: DateTime(2025, 12, 31),
          salePriceCents: 9999,
        ),
      );
      await expenses.save(
        ExpenseDraft(
          description: 'Boxes',
          kind: ExpenseKind.supplies,
          spentAt: DateTime(2026, 2, 1),
          amountCents: 1000,
        ),
      );

      final from = DateTime(2026);
      final to = DateTime(2027);
      final pnl = await exporter.profitAndLoss(from: from, to: to);
      expect(pnl.revenueCents, 30000);
      expect(pnl.grossProfitCents, 30000 - 20000 - 4000 - 1500 - 200);
      expect(pnl.netProfitCents, 4300 - 1000);

      final csv = await exporter.salesCsv(from: from, to: to);
      final lines = csv.trim().split('\r\n');
      expect(lines, hasLength(2));
      expect(
        lines[1],
        '2026-03-01,"Jordan 4, Bred",,,1,Nike SNKRS,,300.00,40.00,15.00,'
        '2.00,200.00,43.00,,',
      );

      final pnlCsv = await exporter.profitAndLossCsv(
        from: from,
        to: to,
        periodLabel: '2026',
      );
      expect(pnlCsv, contains('Expense: Supplies,-10.00'));
      expect(pnlCsv, contains('Net profit,33.00'));

      final inventory = await exporter.inventoryCsv();
      expect(inventory.trim().split('\r\n'), hasLength(3));
    });
  });

  group('barcode lookup', () {
    const body = '''
{"code":"OK","total":1,"offset":0,"items":[{"ean":"0196153948447",
"title":"Nike Air Jordan 4 Retro Bred Reimagined","upc":"196153948447",
"brand":"Nike","color":"Black/Red","size":"","images":[]}]}''';

    test('parses a match and ignores empty results', () {
      final info = parseUpcItemDb(body)!;
      expect(info.title, 'Nike Air Jordan 4 Retro Bred Reimagined');
      expect(info.brand, 'Nike');
      expect(info.size, isNull);
      expect(parseUpcItemDb('{"code":"OK","total":0,"items":[]}'), isNull);
      expect(parseUpcItemDb('{"code":"INVALID_UPC"}'), isNull);
    });

    test('looks up digits only and fails quietly', () async {
      final requested = <Uri>[];
      final lookup = UpcLookup(
        MockClient((request) async {
          requested.add(request.url);
          return request.url.queryParameters['upc'] == '196153948447'
              ? http.Response(body, 200)
              : http.Response('{"code":"TOO_FAST"}', 429);
        }),
      );
      expect((await lookup.lookup('196153948447'))?.brand, 'Nike');
      expect(await lookup.lookup('012345678905'), isNull);
      expect(await lookup.lookup('FV5029-006'), isNull);
      expect(requested, hasLength(2));
    });
  });
}
