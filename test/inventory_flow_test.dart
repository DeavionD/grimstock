import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grimstock/data/database.dart';
import 'package:grimstock/data/providers.dart';
import 'package:grimstock/main.dart';

void main() {
  testWidgets('add an item, see it in the list, estimate profit', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2280);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final db = GrimstockDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const GrimstockApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Inventory'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add item'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Item name'),
      'Jordan 4 Bred',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Price paid'),
      '210',
    );
    await tester.enterText(find.widgetWithText(TextFormField, 'Tax'), '16.80');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Lands on the new item's detail screen.
    expect(find.text('Jordan 4 Bred'), findsOneWidget);
    expect(find.text(r'$226.80'), findsWidgets);

    // eBay is the default platform: 13.6% + $0.40 on $300 = $41.20.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Sale price'),
      '300',
    );
    await tester.pumpAndSettle();
    expect(find.text(r'-$41.20'), findsOneWidget);
    expect(find.text(r'$32.00'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Jordan 4 Bred'), findsOneWidget);
    expect(find.text('In stock'), findsWidgets);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('1 / 25'), findsOneWidget);
    expect(find.text(r'$226.80'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  });
}
