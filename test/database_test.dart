import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grimstock/data/database.dart';

void main() {
  late GrimstockDatabase db;

  setUp(() => db = GrimstockDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('seeds categories with their custom fields and platforms', () async {
    final categories = await db.select(db.categories).get();
    expect(categories.map((c) => c.name), contains('Sneakers'));

    final sneakers = categories.firstWhere((c) => c.name == 'Sneakers');
    final fields = await (db.select(
      db.categoryFields,
    )..where((f) => f.categoryId.equals(sneakers.id))).get();
    expect(fields.map((f) => f.label), ['Style code', 'Colorway']);

    final platforms = await db.select(db.platforms).get();
    expect(platforms.map((p) => p.name), containsAll(['eBay', 'StockX']));
  });

  test('active item count ignores sold and shipped items', () async {
    for (final status in ItemStatus.values) {
      await db
          .into(db.items)
          .insert(
            ItemsCompanion.insert(
              name: 'Item ${status.name}',
              status: Value(status),
            ),
          );
    }
    // purchased, inStock, listed and returned are still active.
    expect(await db.watchActiveItemCount().first, 4);
  });

  test('every row gets a unique sync id', () async {
    await db
        .into(db.purchaseSources)
        .insert(PurchaseSourcesCompanion.insert(name: 'Nike SNKRS'));
    await db
        .into(db.purchaseSources)
        .insert(PurchaseSourcesCompanion.insert(name: 'Goodwill'));
    final ids = (await db.select(db.purchaseSources).get())
        .map((s) => s.syncId)
        .toSet();
    expect(ids, hasLength(2));
    expect(ids.first, matches(RegExp(r'^[0-9a-f-]{36}$')));
  });
}
