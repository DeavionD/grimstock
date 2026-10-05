import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grimstock/core/money.dart';
import 'package:grimstock/data/database.dart';
import 'package:grimstock/data/item_repository.dart';
import 'package:grimstock/data/sales_repository.dart';

void main() {
  late GrimstockDatabase db;
  late ItemRepository items;
  late SalesRepository sales;

  setUp(() {
    db = GrimstockDatabase(NativeDatabase.memory());
    items = ItemRepository(db, activeItemLimit: 2);
    sales = SalesRepository(db, items);
  });
  tearDown(() => db.close());

  Future<Item> item(int id) =>
      (db.select(db.items)..where((i) => i.id.equals(id))).getSingle();

  Future<int> platformId(String name) async => (await (db.select(
    db.platforms,
  )..where((p) => p.name.equals(name))).getSingle()).id;

  test('selling the last unit marks the item sold with a profit', () async {
    final id = await items.saveItem(
      const ItemDraft(
        name: 'Jordan 4 Bred',
        purchasePriceCents: 21000,
        purchaseTaxCents: 1680,
        purchaseSourceName: 'Nike SNKRS',
      ),
    );
    final saleId = await sales.recordSale(
      SaleDraft(
        itemId: id,
        platformId: await platformId('StockX'),
        soldAt: DateTime(2026, 10, 3),
        salePriceCents: 30000,
        platformFeesCents: 3600,
        outboundShippingCents: 0,
        trackingNumber: '  1Z999  ',
      ),
    );

    expect((await item(id)).status, ItemStatus.sold);
    final entry = (await sales.watchSale(saleId).first)!;
    expect(entry.sale.unitCostCents, 22680);
    expect(entry.sale.profitCents, 30000 - 3600 - 22680);
    expect(entry.sale.trackingNumber, '1Z999');
    expect(entry.platform?.name, 'StockX');
    expect(entry.purchaseSource?.name, 'Nike SNKRS');
  });

  test(
    'a partial sale lowers the quantity and keeps the item active',
    () async {
      final id = await items.saveItem(
        const ItemDraft(
          name: 'Pokémon 151 ETB',
          quantity: 5,
          purchasePriceCents: 5000,
        ),
      );
      await sales.recordSale(
        SaleDraft(
          itemId: id,
          quantity: 2,
          soldAt: DateTime.now(),
          salePriceCents: 18000,
        ),
      );
      final after = await item(id);
      expect(after.quantity, 3);
      expect(after.isActive, isTrue);

      await expectLater(
        () => sales.recordSale(
          SaleDraft(
            itemId: id,
            quantity: 4,
            soldAt: DateTime.now(),
            salePriceCents: 1,
          ),
        ),
        throwsA(
          isA<NotEnoughQuantity>().having((e) => e.available, 'available', 3),
        ),
      );
    },
  );

  test(
    'cost is snapshotted, so editing the item later keeps old profit',
    () async {
      final id = await items.saveItem(
        const ItemDraft(name: 'Dunk', quantity: 2, purchasePriceCents: 10000),
      );
      final saleId = await sales.recordSale(
        SaleDraft(itemId: id, soldAt: DateTime.now(), salePriceCents: 15000),
      );
      final draftItem = await item(id);
      await items.saveItem(
        ItemDraft(
          id: id,
          name: draftItem.name,
          quantity: 1,
          purchasePriceCents: 99900,
        ),
      );
      final entry = (await sales.watchSale(saleId).first)!;
      expect(entry.sale.profitCents, 5000);
    },
  );

  test('undo puts units back, or restores a sold item to in stock', () async {
    final multi = await items.saveItem(
      const ItemDraft(name: 'Socks', quantity: 3),
    );
    final partial = await sales.recordSale(
      SaleDraft(itemId: multi, soldAt: DateTime.now(), salePriceCents: 1000),
    );
    await sales.undoSale(partial);
    expect((await item(multi)).quantity, 3);

    final single = await items.saveItem(const ItemDraft(name: 'Hoodie'));
    final full = await sales.recordSale(
      SaleDraft(itemId: single, soldAt: DateTime.now(), salePriceCents: 8000),
    );
    expect((await item(single)).status, ItemStatus.sold);
    await sales.undoSale(full);
    final restored = await item(single);
    expect(restored.status, ItemStatus.inStock);
    expect(restored.quantity, 1);
    expect(await db.select(db.sales).get(), isEmpty);
  });

  test('undo respects the free active item limit', () async {
    final sold = await items.saveItem(const ItemDraft(name: 'Sold one'));
    final saleId = await sales.recordSale(
      SaleDraft(itemId: sold, soldAt: DateTime.now(), salePriceCents: 100),
    );
    // Selling freed a slot; fill both slots again.
    await items.saveItem(const ItemDraft(name: 'A'));
    await items.saveItem(const ItemDraft(name: 'B'));

    await expectLater(
      () => sales.undoSale(saleId),
      throwsA(isA<FreeLimitReached>()),
    );
    expect(await db.select(db.sales).get(), hasLength(1));
  });

  test('mark shipped moves a sold item to shipped', () async {
    final id = await items.saveItem(const ItemDraft(name: 'Tee'));
    final saleId = await sales.recordSale(
      SaleDraft(itemId: id, soldAt: DateTime.now(), salePriceCents: 4000),
    );
    await sales.markShipped(saleId, trackingNumber: '9400');
    final entry = (await sales.watchSale(saleId).first)!;
    expect(entry.sale.shippedAt, isNotNull);
    expect(entry.sale.trackingNumber, '9400');
    expect(entry.item.status, ItemStatus.shipped);
  });

  test(
    'sold archive filters by text and platform; summary sums a month',
    () async {
      final ebay = await platformId('eBay');
      final goat = await platformId('GOAT');
      final a = await items.saveItem(
        const ItemDraft(name: 'Jordan 1', purchasePriceCents: 10000),
      );
      final b = await items.saveItem(
        const ItemDraft(name: 'Yeezy 350', purchasePriceCents: 20000),
      );
      await sales.recordSale(
        SaleDraft(
          itemId: a,
          platformId: ebay,
          soldAt: DateTime(2026, 10, 2),
          salePriceCents: 15000,
        ),
      );
      await sales.recordSale(
        SaleDraft(
          itemId: b,
          platformId: goat,
          soldAt: DateTime(2026, 9, 28),
          salePriceCents: 26000,
        ),
      );

      expect(await sales.watchSold().first, hasLength(2));
      expect(
        (await sales.watchSold(query: 'yeezy').first).single.item.name,
        'Yeezy 350',
      );
      expect(
        (await sales.watchSold(platformId: ebay).first).single.item.name,
        'Jordan 1',
      );

      final october = await sales
          .watchSummary(from: DateTime(2026, 10), to: DateTime(2026, 11))
          .first;
      expect(october.sales, 1);
      expect(october.revenueCents, 15000);
      expect(october.profitCents, 5000);
    },
  );

  test('suggested fees charge per-order fees on each unit', () {
    const ebay = FeeRule(percentBasisPoints: 1360, fixedCents: 40);
    expect(suggestedFees(ebay, 30000, 1), 4120);
    // Two $150 units: (2040 + 40) each.
    expect(suggestedFees(ebay, 30000, 2), 4160);
    expect(suggestedFees(null, 30000, 1), 0);
  });

  test(
    'photos: capped per item, cover is the first, paths come back on delete',
    () async {
      final id = await items.saveItem(const ItemDraft(name: 'Shoe'));
      for (var i = 0; i < ItemRepository.maxPhotosPerItem; i++) {
        await items.addPhoto(id, '/photos/$i.jpg');
      }
      await expectLater(
        () => items.addPhoto(id, '/photos/extra.jpg'),
        throwsStateError,
      );
      expect((await items.watchCoverPhotos().first)[id], '/photos/0.jpg');

      final first = (await items.watchPhotos(id).first).first;
      expect(await items.deletePhoto(first.id), '/photos/0.jpg');
      expect((await items.watchCoverPhotos().first)[id], '/photos/1.jpg');

      expect(await items.deleteItem(id), hasLength(4));
      expect(await db.select(db.itemPhotos).get(), isEmpty);
    },
  );
}
