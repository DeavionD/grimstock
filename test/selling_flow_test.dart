import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grimstock/data/database.dart';
import 'package:grimstock/data/item_repository.dart';
import 'package:grimstock/data/providers.dart';
import 'package:grimstock/data/sales_repository.dart';
import 'package:grimstock/main.dart';

void main() {
  late GrimstockDatabase db;

  Future<void> startApp(
    WidgetTester tester, {
    Future<void> Function()? seed,
  }) async {
    tester.view.physicalSize = const Size(1080, 2280);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    db = GrimstockDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    if (seed != null) await tester.runAsync(seed);
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

  testWidgets('mark an item sold, find it in Sold, undo it', (tester) async {
    await startApp(tester);
    await tester.runAsync(
      () => ItemRepository(db).saveItem(
        const ItemDraft(
          name: 'Jordan 4 Bred',
          purchasePriceCents: 22680,
          purchaseSourceName: 'Nike SNKRS',
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(tab('Inventory'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jordan 4 Bred'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Mark as sold'));
    await tester.tap(find.text('Mark as sold'));
    await tester.pumpAndSettle();

    // eBay is the default: 13.6% + $0.40 on $300 fills in $41.20.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Sale price'),
      '300',
    );
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, '41.20'), findsOneWidget);
    expect(find.text(r'$32.00'), findsOneWidget);

    await tester.ensureVisible(find.text('Record sale'));
    await tester.tap(find.text('Record sale'));
    await tester.pumpAndSettle();

    // Back on the item: it's sold and the sale is listed.
    expect(find.text('Mark as sold'), findsNothing);
    expect(find.text(r'$32.00'), findsWidgets);

    await tester.tap(tab('Sold'));
    await tester.pumpAndSettle();
    expect(find.text('Nike SNKRS → eBay'), findsOneWidget);

    await tester.tap(find.text('Jordan 4 Bred'));
    await tester.pumpAndSettle();
    expect(find.text('-\$41.20'), findsOneWidget);
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Undo sale'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Undo sale'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing sold yet'), findsOneWidget);

    await tester.tap(tab('Home'));
    await tester.pumpAndSettle();
    expect(find.text('1 / 25'), findsOneWidget);

    await unmount(tester);
  });

  testWidgets('home shows this month\'s profit and revenue', (tester) async {
    await startApp(
      tester,
      seed: () async {
        final items = ItemRepository(db);
        final id = await items.saveItem(
          const ItemDraft(name: 'Tee', purchasePriceCents: 1000),
        );
        await SalesRepository(db, items).recordSale(
          SaleDraft(itemId: id, soldAt: DateTime.now(), salePriceCents: 4000),
        );
      },
    );
    expect(find.text(r'$30.00'), findsOneWidget);
    expect(find.text(r'$40.00'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('calculator ranks platforms and adds to inventory', (
    tester,
  ) async {
    await startApp(tester);
    await tester.tap(tab('Calculator'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Buy price'),
      '200',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Expected sale price'),
      '300',
    );
    await tester.pumpAndSettle();

    // Local / Cash has no fees, so it ranks first at $100 profit.
    expect(find.text('Best'), findsOneWidget);
    expect(find.text(r'$100.00'), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('Bought it? Add to inventory'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Bought it? Add to inventory'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, '200.00'), findsOneWidget);

    await unmount(tester);
  });
}
