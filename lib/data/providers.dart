import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';
import 'item_repository.dart';
import 'photo_store.dart';
import 'insights.dart';
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

/// Sales totals from the start of [Period] until now.
final periodSummaryProvider = StreamProvider.family<SalesSummary, Period>(
  (ref, period) => ref
      .watch(salesRepositoryProvider)
      .watchSummary(from: period.start(DateTime.now())),
);

/// Every sale with its item, platform and source, newest first.
final allSoldProvider = StreamProvider<List<SoldEntry>>(
  (ref) => ref.watch(salesRepositoryProvider).watchSold(),
);

/// Insights for sales from the start of [Period] until now.
final insightsProvider = Provider.family<AsyncValue<Insights>, Period>((
  ref,
  period,
) {
  final categories = ref.watch(categoriesProvider).value ?? const [];
  final start = period.start(DateTime.now());
  return ref
      .watch(allSoldProvider)
      .whenData(
        (entries) => buildInsights(
          [
            for (final e in entries)
              if (start == null || !e.sale.soldAt.isBefore(start)) e,
          ],
          categoryNames: {for (final c in categories) c.id: c.name},
        ),
      );
});

/// Active items, oldest first, for the aging stock card.
final agingStockProvider = StreamProvider<AgingStock>(
  (ref) => ref
      .watch(itemRepositoryProvider)
      .watchItems(sort: ItemSort.oldest)
      .map(
        (entries) => AgingStock(
          [
            for (final e in entries)
              if (e.item.isActive) e,
          ]..sort(
            (a, b) => (a.item.purchaseDate ?? a.item.createdAt).compareTo(
              b.item.purchaseDate ?? b.item.createdAt,
            ),
          ),
          DateTime.now(),
        ),
      ),
);
