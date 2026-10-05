import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';
import 'item_repository.dart';

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
