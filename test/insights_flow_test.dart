import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grimstock/data/database.dart';
import 'package:grimstock/data/item_repository.dart';
import 'package:grimstock/data/providers.dart';
import 'package:grimstock/data/sales_repository.dart';
import 'package:grimstock/main.dart';

void main() {
  late GrimstockDatabase db;

  /// One item sold on eBay this week, and one sitting unsold for 100 days.
  Future<void> seed() async {
    final items = ItemRepository(db);
    final ebay = (await (db.select(
      db.platforms,
    )..where((p) => p.name.equals('eBay'))).getSingle()).id;
    final sold = await items.saveItem(
      const ItemDraft(
        name: 'Jordan 4 Bred',
        brand: 'Nike',
        purchaseSourceName: 'Nike SNKRS',
        purchasePriceCents: 20000,
      ),
    );
    await SalesRepository(db, items).recordSale(
      SaleDraft(
        itemId: sold,
        platformId: ebay,
        soldAt: DateTime.now(),
        salePriceCents: 30000,
        platformFeesCents: 4120,
      ),
    );
    await items.saveItem(
      ItemDraft(
        name: 'Dead stock hoodie',
        sizeVariant: 'L',
        purchaseDate: DateTime.now().subtract(const Duration(days: 100)),
      ),
    );
  }

  Future<void> startApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2280);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    db = GrimstockDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await tester.runAsync(seed);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const GrimstockApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder tab(String label) => find.descendant(
    of: find.byType(NavigationBar),
    matching: find.text(label),
  );

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  }

  testWidgets('dashboard shows best platform and aging stock', (tester) async {
    await startApp(tester);

    // $300 - $41.20 fees - $200 cost.
    expect(find.text(r'$58.80'), findsWidgets);
    expect(find.text('Best platform'), findsOneWidget);
    expect(find.text('eBay'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Dead stock hoodie'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('Dead stock hoodie'));
    await tester.pumpAndSettle();
    expect(find.text('Aging stock'), findsOneWidget);
    expect(find.text('100 days'), findsOneWidget);

    await tester.tap(find.text('Dead stock hoodie'));
    await tester.pumpAndSettle();
    expect(find.text('Write listing'), findsOneWidget);

    await unmount(tester);
  });

  testWidgets('insights tab ranks platforms and sources', (tester) async {
    await startApp(tester);
    await tester.tap(tab('Insights'));
    await tester.pumpAndSettle();

    expect(find.text('Where you sell best'), findsOneWidget);
    expect(find.text('eBay'), findsWidgets);
    expect(find.text('Best places to buy'), findsOneWidget);
    expect(find.text('Nike SNKRS'), findsOneWidget);

    await unmount(tester);
  });

  testWidgets('write a listing and copy it', (tester) async {
    final copied = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied.add((call.arguments as Map)['text'] as String);
        }
        return null;
      },
    );
    await startApp(tester);
    await tester.tap(tab('Inventory'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dead stock hoodie'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Write listing'));
    await tester.tap(find.text('Write listing'));
    await tester.pumpAndSettle();

    expect(
      find.widgetWithText(TextField, 'Dead stock hoodie L'),
      findsOneWidget,
    );
    await tester.tap(find.text('Depop / Poshmark / Mercari'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Copy title and description'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Copy title and description'));
    await tester.pumpAndSettle();
    expect(copied.single, contains('#resell'));
    expect(find.text('Listing copied'), findsOneWidget);

    await unmount(tester);
  });
}
