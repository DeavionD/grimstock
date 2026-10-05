import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';
import 'item_repository.dart';
import 'photo_store.dart';
import 'sales_repository.dart';

/// The app's single local database. Overridden in tests with an in-memory one.
final databaseProvider = Provider<GrimstockDatabase>((ref) {
  final db = GrimstockDatabase();
  ref.onDispose(db.close);
  return db;
});

final activeItemCountProvider = StreamProvider<int>(
  (ref) => ref.watch(databaseProvider).watchActiveItemCount(),
);

final platformsProvider = StreamProvider<List<Platform>>(
  (ref) => ref.watch(databaseProvider).watchPlatforms(),
);

final categoriesProvider = StreamProvider<List<Category>>(
  (ref) => ref.watch(databaseProvider).watchCategories(),
);

/// Free plan limit on items that aren't sold yet.
const freeActiveItemLimit = 25;

final itemRepositoryProvider = Provider<ItemRepository>(
  (ref) => ItemRepository(
    ref.watch(databaseProvider),
    activeItemLimit: freeActiveItemLimit,
  ),
);

final moneyInStockProvider = StreamProvider<int>(
  (ref) => ref.watch(itemRepositoryProvider).watchMoneyInStock(),
);

final itemDetailsProvider = StreamProvider.family<ItemDetails?, int>(
  (ref, id) => ref.watch(itemRepositoryProvider).watchItem(id),
);

final purchaseSourcesProvider = StreamProvider<List<PurchaseSource>>(
  (ref) => ref.watch(itemRepositoryProvider).watchPurchaseSources(),
);

final salesRepositoryProvider = Provider<SalesRepository>(
  (ref) => SalesRepository(
    ref.watch(databaseProvider),
    ref.watch(itemRepositoryProvider),
  ),
);

final photoStoreProvider = Provider<PhotoStore>((ref) => PhotoStore());

final itemPhotosProvider = StreamProvider.family<List<ItemPhoto>, int>(
  (ref, itemId) => ref.watch(itemRepositoryProvider).watchPhotos(itemId),
);

final coverPhotosProvider = StreamProvider<Map<int, String>>(
  (ref) => ref.watch(itemRepositoryProvider).watchCoverPhotos(),
);

final itemSalesProvider = StreamProvider.family<List<Sale>, int>(
  (ref, itemId) => ref.watch(salesRepositoryProvider).watchSalesForItem(itemId),
);

final saleProvider = StreamProvider.family<SoldEntry?, int>(
  (ref, saleId) => ref.watch(salesRepositoryProvider).watchSale(saleId),
);

/// Sales totals for the current calendar month.
final thisMonthSummaryProvider = StreamProvider<SalesSummary>((ref) {
  final now = DateTime.now();
  return ref
      .watch(salesRepositoryProvider)
      .watchSummary(
        from: DateTime(now.year, now.month),
        to: DateTime(now.year, now.month + 1),
      );
});
