import 'dart:io';

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
    expect(categories.map((c) => c.name), contains('Appliances'));

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

  test('upgrading from version 1 adds Appliances once', () async {
    final dir = await Directory.systemTemp.createTemp('grimstock');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/v1.sqlite');

    // A version 1 database: no Appliances.
    final v1 = GrimstockDatabase(NativeDatabase(file));
    final appliances = await (v1.select(
      v1.categories,
    )..where((c) => c.name.equals('Appliances'))).getSingle();
    await (v1.delete(
      v1.categoryFields,
    )..where((f) => f.categoryId.equals(appliances.id))).go();
    await v1.delete(v1.categories).delete(appliances);
    await v1.customStatement('PRAGMA user_version = 1');
    await v1.close();

    final v2 = GrimstockDatabase(NativeDatabase(file));
    addTearDown(v2.close);
    final added = await (v2.select(
      v2.categories,
    )..where((c) => c.name.equals('Appliances'))).get();
    expect(added, hasLength(1));
    final fields = await (v2.select(
      v2.categoryFields,
    )..where((f) => f.categoryId.equals(added.single.id))).get();
    expect(fields.map((f) => f.label), ['Model', 'Serial number']);
  });
}
