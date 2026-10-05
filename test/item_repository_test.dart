import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grimstock/data/database.dart';
import 'package:grimstock/data/item_repository.dart';
import 'package:grimstock/data/platform_presets.dart';

void main() {
  late GrimstockDatabase db;
  late ItemRepository repo;

  setUp(() {
    db = GrimstockDatabase(NativeDatabase.memory());
    repo = ItemRepository(db, activeItemLimit: 3);
  });
  tearDown(() => db.close());

  Future<int> sneakersId() async => (await (db.select(
    db.categories,
  )..where((c) => c.name.equals('Sneakers'))).getSingle()).id;

  test('saves an item with custom fields and a purchase source', () async {
    final categoryId = await sneakersId();
    final fields = await repo.getCategoryFields(categoryId);
    final styleCode = fields.firstWhere((f) => f.label == 'Style code');

    final id = await repo.saveItem(
      ItemDraft(
        name: '  Jordan 4 Bred  ',
        categoryId: categoryId,
        sizeVariant: '10.5',
        purchaseSourceName: 'Nike SNKRS',
        purchasePriceCents: 21000,
        purchaseTaxCents: 1680,
        fieldValues: {styleCode.id: 'FV5029-006'},
      ),
    );

    final details = (await repo.watchItem(id).first)!;
    expect(details.item.name, 'Jordan 4 Bred');
    expect(details.item.unitCostCents, 22680);
    expect(details.category?.name, 'Sneakers');
    expect(details.purchaseSource?.name, 'Nike SNKRS');
    expect(details.fields.first.$2, 'FV5029-006');

    // Same source name (any case) is reused, not duplicated.
    await repo.saveItem(
      const ItemDraft(name: 'Dunk Low', purchaseSourceName: 'nike snkrs'),
    );
    expect(await db.select(db.purchaseSources).get(), hasLength(1));
  });

  test('editing updates the item and replaces field values', () async {
    final categoryId = await sneakersId();
    final colorway = (await repo.getCategoryFields(categoryId))
        .firstWhere((f) => f.label == 'Colorway');
    final id = await repo.saveItem(
      ItemDraft(
        name: 'Dunk',
        categoryId: categoryId,
        fieldValues: {colorway.id: 'Panda'},
      ),
    );
    await repo.saveItem(
      ItemDraft(
        id: id,
        name: 'Dunk Low',
        categoryId: categoryId,
        fieldValues: {colorway.id: 'Reverse Panda'},
      ),
    );
    final details = (await repo.watchItem(id).first)!;
    expect(details.item.name, 'Dunk Low');
    expect(details.fields.map((f) => f.$2), contains('Reverse Panda'));
    expect(await db.select(db.itemFieldValues).get(), hasLength(1));
  });

  test('blocks new active items past the free limit', () async {
    for (var i = 0; i < 3; i++) {
      await repo.saveItem(ItemDraft(name: 'Item $i'));
    }
    expect(
      () => repo.saveItem(const ItemDraft(name: 'One too many')),
      throwsA(isA<FreeLimitReached>()),
    );
    // Sold items don't count, so selling one frees a spot.
    final first = (await db.select(db.items).get()).first;
    await repo.updateStatus(first.id, ItemStatus.sold);
    await repo.saveItem(const ItemDraft(name: 'Now it fits'));
    // Moving a sold item back to active also respects the limit.
    expect(
      () => repo.updateStatus(first.id, ItemStatus.inStock),
      throwsA(isA<FreeLimitReached>()),
    );
  });

  test('duplicates an item as new stock with the same fields', () async {
    final categoryId = await sneakersId();
    final fields = await repo.getCategoryFields(categoryId);
    final id = await repo.saveItem(
      ItemDraft(
        name: 'Yeezy 350',
        categoryId: categoryId,
        status: ItemStatus.listed,
        purchasePriceCents: 23000,
        fieldValues: {fields.first.id: 'HQ6316'},
      ),
    );
    final copyId = await repo.duplicateItem(id);
    final copy = (await repo.watchItem(copyId).first)!;
    expect(copyId, isNot(id));
    expect(copy.item.name, 'Yeezy 350');
    expect(copy.item.status, ItemStatus.inStock);
    expect(copy.item.purchasePriceCents, 23000);
    expect(copy.fields.first.$2, 'HQ6316');
  });

  test('items with sales cannot be deleted', () async {
    final keep = await repo.saveItem(const ItemDraft(name: 'Sold pair'));
    await db
        .into(db.sales)
        .insert(
          SalesCompanion.insert(
            itemId: keep,
            soldAt: DateTime(2026, 10, 1),
            salePriceCents: 30000,
          ),
        );
    expect(() => repo.deleteItem(keep), throwsA(isA<ItemHasSales>()));

    final gone = await repo.saveItem(const ItemDraft(name: 'Mistake'));
    await repo.deleteItem(gone);
    expect(await repo.watchItem(gone).first, isNull);
  });

  test('money in stock sums active items times quantity', () async {
    await repo.saveItem(
      const ItemDraft(
        name: 'Two pairs',
        quantity: 2,
        purchasePriceCents: 10000,
        purchaseTaxCents: 800,
      ),
    );
    await repo.saveItem(
      const ItemDraft(
        name: 'Already sold',
        status: ItemStatus.sold,
        purchasePriceCents: 50000,
      ),
    );
    expect(await repo.watchMoneyInStock().first, 21600);
  });

  test('search, status filter and sort', () async {
    await repo.saveItem(
      const ItemDraft(
        name: 'Jordan 1',
        brand: 'Nike',
        purchasePriceCents: 18000,
      ),
    );
    await repo.saveItem(
      const ItemDraft(
        name: 'Pokemon Charizard',
        status: ItemStatus.listed,
        purchasePriceCents: 40000,
      ),
    );
    await repo.saveItem(const ItemDraft(name: 'Air Max', brand: 'Nike'));

    Future<List<String>> names({
      String query = '',
      ItemStatus? status,
      ItemSort sort = ItemSort.nameAToZ,
    }) async => [
      for (final e
          in await repo
              .watchItems(query: query, status: status, sort: sort)
              .first)
        e.item.name,
    ];

    expect(await names(query: 'nike'), ['Air Max', 'Jordan 1']);
    expect(await names(status: ItemStatus.listed), ['Pokemon Charizard']);
    expect(await names(sort: ItemSort.costHighToLow), [
      'Pokemon Charizard',
      'Jordan 1',
      'Air Max',
    ]);
  });

  test('seeded fee presets match the documented fees', () async {
    final platforms = {
      for (final p in await db.select(db.platforms).get()) p.name: p.feeRule,
    };
    expect(platforms['eBay']!.feesFor(10000), 1400);
    expect(platforms['StockX']!.feesFor(10000), 1200);
    expect(platforms['StockX']!.feesFor(2000), 500);
    expect(platforms['GOAT']!.feesFor(20000), 2980);
    expect(platforms['Mercari']!.feesFor(10000), 1000);
    expect(platforms['Poshmark']!.feesFor(1000), 295);
    expect(platforms['Depop']!.feesFor(10000), 375);
    expect(platforms['Local / Cash']!.feesFor(10000), 0);
  });

  test('platform fees can be edited', () async {
    final stockx = await (db.select(
      db.platforms,
    )..where((p) => p.name.equals('StockX'))).getSingle();
    await db.updatePlatform(
      stockx.copyWith(feeBasisPoints: 800, note: const Value('Level 3')),
    );
    final updated = await (db.select(
      db.platforms,
    )..where((p) => p.id.equals(stockx.id))).getSingle();
    expect(updated.feeBasisPoints, 800);
    expect(updated.note, 'Level 3');
    expect(updated.feeSummary, r'11%, $5.00 min');
  });
}
