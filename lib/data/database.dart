import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// Where an item is in its life. Stored by name, so never rename a value
/// without a migration.
enum ItemStatus { purchased, inStock, listed, sold, shipped, returned }

/// Columns every synced table shares. `syncId` is the stable id used by
/// Pro cloud sync; `updatedAt` decides which copy wins.
mixin SyncColumns on Table {
  TextColumn get syncId => text().clientDefault(newSyncId).unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Categories extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 60)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// Extra fields a category adds to its items, e.g. "Style code" for sneakers
/// or "Grade" for trading cards. Keeps the app category-agnostic.
class CategoryFields extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get label => text().withLength(min: 1, max: 40)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// Selling platforms and their fee presets. Fees are editable by the user.
class Platforms extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 60)();
  IntColumn get feeBasisPoints => integer().withDefault(const Constant(0))();
  IntColumn get fixedFeeCents => integer().withDefault(const Constant(0))();
  IntColumn get processingBasisPoints =>
      integer().withDefault(const Constant(0))();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
}

/// Where items are bought: stores, sites, raffles, thrift. Feeds Insights.
class PurchaseSources extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 60)();
}

class Items extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id)();
  TextColumn get brand => text().nullable()();
  TextColumn get sizeVariant => text().nullable()();
  TextColumn get condition => text().nullable()();
  TextColumn get sku => text().nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  TextColumn get status =>
      textEnum<ItemStatus>().withDefault(Constant(ItemStatus.inStock.name))();
  DateTimeColumn get purchaseDate => dateTime().nullable()();
  IntColumn get purchaseSourceId =>
      integer().nullable().references(PurchaseSources, #id)();
  TextColumn get storageLocation => text().nullable()();
  TextColumn get notes => text().nullable()();

  /// Costs per unit, in cents.
  IntColumn get purchasePriceCents =>
      integer().withDefault(const Constant(0))();
  IntColumn get purchaseTaxCents => integer().withDefault(const Constant(0))();
  IntColumn get inboundShippingCents =>
      integer().withDefault(const Constant(0))();
  IntColumn get otherCostsCents => integer().withDefault(const Constant(0))();
}

class ItemFieldValues extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().references(Items, #id)();
  IntColumn get fieldId => integer().references(CategoryFields, #id)();
  TextColumn get value => text()();
}

class ItemPhotos extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().references(Items, #id)();
  TextColumn get localPath => text()();
  TextColumn get remotePath => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// One row per unit sold, so multi-quantity items can sell one at a time.
/// Sold rows are never deleted: they are the Sold archive and feed Insights.
class Sales extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().references(Items, #id)();
  IntColumn get platformId => integer().nullable().references(Platforms, #id)();
  DateTimeColumn get soldAt => dateTime()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  IntColumn get salePriceCents => integer()();
  IntColumn get platformFeesCents => integer().withDefault(const Constant(0))();
  IntColumn get outboundShippingCents =>
      integer().withDefault(const Constant(0))();
  IntColumn get packagingCents => integer().withDefault(const Constant(0))();
  TextColumn get trackingNumber => text().nullable()();
}

class Expenses extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text()();
  TextColumn get kind => text()(); // supplies, subscription, mileage, ...
  DateTimeColumn get spentAt => dateTime()();
  IntColumn get amountCents => integer()();
  RealColumn get miles => real().nullable()();
}

@DriftDatabase(
  tables: [
    Categories,
    CategoryFields,
    Platforms,
    PurchaseSources,
    Items,
    ItemFieldValues,
    ItemPhotos,
    Sales,
    Expenses,
  ],
)
class GrimstockDatabase extends _$GrimstockDatabase {
  GrimstockDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'grimstock'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedDefaults();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _seedDefaults() async {
    const defaultFields = {
      'Sneakers': ['Style code', 'Colorway'],
      'Streetwear': ['Colorway'],
      'Trading Cards': ['Set', 'Grade'],
      'Electronics': ['Model', 'Serial number'],
      'Collectibles': [],
      'Other': [],
    };
    var order = 0;
    for (final entry in defaultFields.entries) {
      final categoryId = await into(categories).insert(
        CategoriesCompanion.insert(name: entry.key, sortOrder: Value(order++)),
      );
      var fieldOrder = 0;
      for (final label in entry.value) {
        await into(categoryFields).insert(
          CategoryFieldsCompanion.insert(
            categoryId: categoryId,
            label: label,
            sortOrder: Value(fieldOrder++),
          ),
        );
      }
    }

    // Fee values are filled in milestone 2, after checking each platform's
    // current fee page. Until then every preset starts at 0%.
    const platformNames = [
      'eBay',
      'StockX',
      'GOAT',
      'Mercari',
      'Poshmark',
      'Depop',
      'Facebook Marketplace',
      'Local / Cash',
    ];
    for (final name in platformNames) {
      await into(platforms).insert(PlatformsCompanion.insert(name: name));
    }
  }

  /// Items that count toward the free plan's limit (anything not yet sold).
  Stream<int> watchActiveItemCount() {
    final count = items.id.count();
    final query = selectOnly(items)
      ..addColumns([count])
      ..where(
        items.status.isNotIn([ItemStatus.sold.name, ItemStatus.shipped.name]),
      );
    return query.map((row) => row.read(count) ?? 0).watchSingle();
  }

  Stream<List<Category>> watchCategories() => (select(
    categories,
  )..orderBy([(c) => OrderingTerm(expression: c.sortOrder)])).watch();

  Stream<List<Platform>> watchPlatforms() => (select(
    platforms,
  )..orderBy([(p) => OrderingTerm(expression: p.id)])).watch();
}

final _random = Random.secure();

/// Random 128-bit id in UUID v4 format, used as the cross-device sync id.
String newSyncId() {
  final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}
