import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';

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
