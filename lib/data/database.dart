import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'platform_presets.dart';

part 'database.g.dart';

/// Where an item is in its life. Stored by name, so never rename a value
/// without a migration.
enum ItemStatus { purchased, inStock, listed, sold, shipped, returned }

/// Statuses that count as "active" stock (not yet sold). Active items count
/// toward the free plan's limit.
const activeStatuses = [
  ItemStatus.purchased,
  ItemStatus.inStock,
  ItemStatus.listed,
  ItemStatus.returned,
];

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
  IntColumn get minimumFeeCents => integer().withDefault(const Constant(0))();
  IntColumn get smallSaleThresholdCents =>
      integer().withDefault(const Constant(0))();
  IntColumn get smallSaleFlatFeeCents =>
      integer().withDefault(const Constant(0))();

  /// Shown under the platform name, e.g. "Seller Level 1".
  TextColumn get note => text().nullable()();
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

/// One row per sale. A sale can cover several units of a multi-quantity
/// item. Amounts are totals for the whole sale, and [unitCostCents] is a
/// snapshot of the item's cost when it sold, so later edits to the item
/// don't change past profit. Sales are never deleted except by "Undo sale":
/// they are the Sold archive and feed Insights.
class Sales extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().references(Items, #id)();
  IntColumn get platformId => integer().nullable().references(Platforms, #id)();
  DateTimeColumn get soldAt => dateTime()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  IntColumn get unitCostCents => integer().withDefault(const Constant(0))();
  IntColumn get salePriceCents => integer()();
  IntColumn get platformFeesCents => integer().withDefault(const Constant(0))();
  IntColumn get outboundShippingCents =>
      integer().withDefault(const Constant(0))();
  IntColumn get packagingCents => integer().withDefault(const Constant(0))();
  TextColumn get trackingNumber => text().nullable()();
  DateTimeColumn get shippedAt => dateTime().nullable()();
}

class Expenses extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text()();
  TextColumn get kind => text()(); // supplies, subscription, mileage, ...
  DateTimeColumn get spentAt => dateTime()();
  IntColumn get amountCents => integer()();
  RealColumn get miles => real().nullable()();
}

/// Small app settings, e.g. the mileage rate. Kept on this device.
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    AppSettings,
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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedDefaults();
    },
    onUpgrade: (m, from, to) async {
      // Version 2 (test builds from 2026-10-06): Appliances category.
      if (from < 2) {
        await _addCategory('Appliances', ['Model', 'Serial number']);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Adds a category with custom fields at the end of the list, unless one
  /// with that name already exists.
  Future<void> _addCategory(String name, List<String> fields) async {
    final existing = await (select(
      categories,
    )..where((c) => c.name.equals(name))).getSingleOrNull();
    if (existing != null) return;
    final last =
        await (select(categories)
              ..orderBy([(c) => OrderingTerm.desc(c.sortOrder)])
              ..limit(1))
            .getSingleOrNull();
    final id = await into(categories).insert(
      CategoriesCompanion.insert(
        name: name,
        sortOrder: Value((last?.sortOrder ?? -1) + 1),
      ),
    );
    for (final (i, label) in fields.indexed) {
      await into(categoryFields).insert(
        CategoryFieldsCompanion.insert(
          categoryId: id,
          label: label,
          sortOrder: Value(i),
        ),
      );
    }
  }

  Future<void> _seedDefaults() async {
    const defaultFields = {
      'Sneakers': ['Style code', 'Colorway'],
      'Streetwear': ['Colorway'],
      'Trading Cards': ['Set', 'Grade'],
      'Electronics': ['Model', 'Serial number'],
      'Appliances': ['Model', 'Serial number'],
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

    for (final preset in defaultPlatformPresets) {
      await into(platforms).insert(preset);
    }
  }

  /// Items that count toward the free plan's limit (anything not yet sold).
  Stream<int> watchActiveItemCount() {
    final count = items.id.count();
    final query = selectOnly(items)
      ..addColumns([count])
      ..where(items.status.isInValues(activeStatuses));
    return query.map((row) => row.read(count) ?? 0).watchSingle();
  }

  Stream<List<Category>> watchCategories() => (select(
    categories,
  )..orderBy([(c) => OrderingTerm(expression: c.sortOrder)])).watch();

  Future<void> updatePlatform(Platform platform) =>
      update(platforms).replace(platform.copyWith(updatedAt: DateTime.now()));

  Stream<String?> watchSetting(String key) =>
      (select(appSettings)..where((s) => s.key.equals(key)))
          .watchSingleOrNull()
          .map((row) => row?.value);

  Future<String?> getSetting(String key) async => (await (select(
    appSettings,
  )..where((s) => s.key.equals(key))).getSingleOrNull())?.value;

  Future<void> setSetting(String key, String value) => into(
    appSettings,
  ).insertOnConflictUpdate(AppSettingsCompanion.insert(key: key, value: value));

  Future<int> addPlatform(String name) => into(
    platforms,
  ).insert(PlatformsCompanion.insert(name: name, isCustom: const Value(true)));

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
