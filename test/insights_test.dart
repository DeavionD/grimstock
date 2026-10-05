import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grimstock/data/database.dart';
import 'package:grimstock/data/insights.dart';
import 'package:grimstock/data/item_repository.dart';
import 'package:grimstock/data/listing_writer.dart';
import 'package:grimstock/data/sales_repository.dart';

void main() {
  late GrimstockDatabase db;
  late ItemRepository items;
  late SalesRepository sales;

  setUp(() {
    db = GrimstockDatabase(NativeDatabase.memory());
    items = ItemRepository(db);
    sales = SalesRepository(db, items);
  });
  tearDown(() => db.close());

  Future<int> platformId(String name) async => (await (db.select(
    db.platforms,
  )..where((p) => p.name.equals(name))).getSingle()).id;

  Future<int> categoryId(String name) async => (await (db.select(
    db.categories,
  )..where((c) => c.name.equals(name))).getSingle()).id;

  Future<void> sell(
    String name, {
    required String platform,
    required String source,
    required int cost,
    required int price,
    int fees = 0,
    String? brand,
    int? category,
    int daysToSell = 10,
  }) async {
    final soldAt = DateTime(2026, 9, 30);
    final id = await items.saveItem(
      ItemDraft(
        name: name,
        brand: brand,
        categoryId: category,
        purchaseSourceName: source,
        purchasePriceCents: cost,
        purchaseDate: soldAt.subtract(Duration(days: daysToSell)),
      ),
    );
    await sales.recordSale(
      SaleDraft(
        itemId: id,
        platformId: await platformId(platform),
        soldAt: soldAt,
        salePriceCents: price,
        platformFeesCents: fees,
      ),
    );
  }

  test('groups sales by platform, source, category and brand', () async {
    final sneakers = await categoryId('Sneakers');
    await sell(
      'Jordan 4',
      platform: 'eBay',
      source: 'Nike SNKRS',
      cost: 20000,
      price: 30000,
      fees: 4000,
      brand: 'Nike',
      category: sneakers,
      daysToSell: 4,
    );
    await sell(
      'Dunk Low',
      platform: 'eBay',
      source: 'Foot Locker',
      cost: 11000,
      price: 15000,
      fees: 2000,
      brand: 'nike',
      category: sneakers,
      daysToSell: 20,
    );
    await sell(
      'Yeezy 350',
      platform: 'StockX',
      source: 'Nike SNKRS',
      cost: 23000,
      price: 26000,
      fees: 3100,
      brand: 'Adidas',
      category: sneakers,
      daysToSell: 60,
    );

    final categories = {
      for (final c in await db.select(db.categories).get()) c.id: c.name,
    };
    final insights = buildInsights(
      await sales.watchSold().first,
      categoryNames: categories,
    );

    expect(insights.totals.sales, 3);
    expect(insights.totals.profitCents, 6000 + 2000 - 100);

    final ebay = insights.platforms.first;
    expect(ebay.name, 'eBay');
    expect(ebay.units, 2);
    expect(ebay.profitCents, 8000);
    expect(ebay.averageDaysToSell, 12);
    expect(ebay.averageFeesCents, 3000);
    expect(insights.platforms.last.profitCents, -100);

    // Nike SNKRS: 5900 profit on 43000 cost; Foot Locker: 2000 on 11000.
    expect(insights.bestSource?.name, 'Foot Locker');
    expect(insights.sources.first.name, 'Nike SNKRS');

    expect(insights.bestCategory?.name, 'Sneakers');
    // "Nike" and "nike" count as one brand.
    expect(insights.brands.first.name, 'Nike');
    expect(insights.brands.first.sales, 2);

    expect(insights.slowest.first.item.name, 'Yeezy 350');
  });

  test('no sales means empty insights', () {
    final insights = buildInsights(const []);
    expect(insights.isEmpty, isTrue);
    expect(insights.bestPlatform, isNull);
    expect(insights.bestSource, isNull);
  });

  test('periods start on Monday, the 1st, and January 1st', () {
    final now = DateTime(2026, 10, 8, 15); // A Thursday.
    expect(Period.week.start(now), DateTime(2026, 10, 5));
    expect(Period.month.start(now), DateTime(2026, 10));
    expect(Period.year.start(now), DateTime(2026));
    expect(Period.allTime.start(now), isNull);
  });

  test('aging stock buckets active items by days unsold', () async {
    final now = DateTime(2026, 10, 5);
    for (final days in [5, 35, 61, 95, 120]) {
      await items.saveItem(
        ItemDraft(
          name: '$days days',
          purchaseDate: now.subtract(Duration(days: days)),
        ),
      );
    }
    final aging = AgingStock(
      await items.watchItems(sort: ItemSort.oldest).first,
      now,
    );
    expect(aging.days30to59, 1);
    expect(aging.days60to89, 1);
    expect(aging.days90plus, 2);
    expect(aging.stale, hasLength(4));
  });

  group('listing writer', () {
    Future<ItemDetails> sneaker({String condition = 'New'}) async {
      final category = await categoryId('Sneakers');
      final fields = await items.getCategoryFields(category);
      final id = await items.saveItem(
        ItemDraft(
          name: 'Air Jordan 4 Retro Bred Reimagined',
          brand: 'Nike',
          categoryId: category,
          sizeVariant: '10.5',
          condition: condition,
          notes: 'Worn once, comes with extra laces.',
          fieldValues: {
            fields.firstWhere((f) => f.label == 'Style code').id: 'FV5029-006',
            fields.firstWhere((f) => f.label == 'Colorway').id: 'Black/Red',
          },
        ),
      );
      return (await items.watchItem(id).first)!;
    }

    test('eBay title packs keywords and stays within 80 characters', () async {
      final listing = writeListing(await sneaker(), ListingStyle.ebay);
      expect(
        listing.title,
        'Nike Air Jordan 4 Retro Bred Reimagined Black/Red Size 10.5 FV5029-006 New',
      );
      expect(listing.title.length, lessThanOrEqualTo(80));
      expect(listing.description, contains('• Style code: FV5029-006'));
      expect(listing.description, contains('100% authentic.'));
      expect(listing.description, contains('extra laces'));
    });

    test('short and casual styles', () async {
      final details = await sneaker(condition: 'Used - Good');
      final short = writeListing(details, ListingStyle.short);
      expect(short.title, 'Nike Air Jordan 4 Retro Bred Reimagined Size 10.5');

      final casual = writeListing(details, ListingStyle.casual);
      expect(casual.title.length, lessThanOrEqualTo(50));
      expect(casual.description, contains('#nike'));
      expect(casual.description, contains('#sneakers'));
      expect(casual.description, isNot(contains('100% authentic')));
    });

    test('does not repeat the brand and skips empty fields', () async {
      final id = await items.saveItem(
        const ItemDraft(name: 'Nike Tech Fleece Hoodie', brand: 'Nike'),
      );
      final listing = writeListing(
        (await items.watchItem(id).first)!,
        ListingStyle.standard,
      );
      expect(listing.title, 'Nike Tech Fleece Hoodie');
      expect(listing.description, isNot(contains('Size:')));
    });
  });
}
