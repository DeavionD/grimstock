import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'database.dart';
import 'expense_repository.dart';
import 'export.dart';
import 'item_repository.dart';
import 'photo_store.dart';
import 'pro.dart';
import 'receipt_reader.dart';
import 'receipt_repository.dart';
import 'insights.dart';
import 'sales_repository.dart';
import 'upc_lookup.dart';

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
const freeActiveItemLimit = FreeLimits.activeItems;

/// Whether Pro is unlocked. A stand-in switch in Settings drives it until
/// store purchases are connected; then this reads the store entitlement.
final isProProvider = Provider<bool>(
  (ref) => ref.watch(_devProProvider).value == 'true',
);

final _devProProvider = StreamProvider<String?>(
  (ref) => ref.watch(databaseProvider).watchSetting(devProSettingKey),
);

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  final pro = ref.watch(isProProvider);
  return ItemRepository(
    ref.watch(databaseProvider),
    activeItemLimit: pro ? null : FreeLimits.activeItems,
    photoLimit: pro
        ? ItemRepository.maxPhotosPerItem
        : FreeLimits.photosPerItem,
  );
});

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

final expenseRepositoryProvider = Provider<ExpenseRepository>(
  (ref) => ExpenseRepository(ref.watch(databaseProvider)),
);

final mileageRateProvider = StreamProvider<double>(
  (ref) => ref.watch(expenseRepositoryProvider).watchMileageRate(),
);

final expensesProvider = StreamProvider<List<Expense>>(
  (ref) => ref.watch(expenseRepositoryProvider).watchExpenses(),
);

final expenseProvider = StreamProvider.family<Expense?, int>(
  (ref, id) => ref.watch(expenseRepositoryProvider).watchExpense(id),
);

/// Expenses from the start of [Period] until now.
final periodExpensesProvider = StreamProvider.family<int, Period>(
  (ref, period) => ref
      .watch(expenseRepositoryProvider)
      .watchTotal(from: period.start(DateTime.now())),
);

final exporterProvider = Provider<Exporter>(
  (ref) => Exporter(
    ref.watch(databaseProvider),
    ref.watch(salesRepositoryProvider),
    ref.watch(expenseRepositoryProvider),
    ref.watch(receiptRepositoryProvider),
  ),
);

final receiptRepositoryProvider = Provider<ReceiptRepository>(
  (ref) => ReceiptRepository(
    ref.watch(databaseProvider),
    ref.watch(expenseRepositoryProvider),
  ),
);

final receiptsProvider = StreamProvider<List<Receipt>>(
  (ref) => ref.watch(receiptRepositoryProvider).watchReceipts(),
);

final receiptReaderProvider = Provider<ReceiptReader>(
  (ref) => MlKitReceiptReader(),
);

final upcLookupProvider = Provider<UpcLookup>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return UpcLookup(client);
});
