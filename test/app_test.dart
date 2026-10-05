import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grimstock/data/database.dart';
import 'package:grimstock/data/providers.dart';
import 'package:grimstock/main.dart';

/// Drift closes stream queries on a zero-length timer. Unmount the app and
/// flush that timer before the test ends so no timers are left pending.
Future<void> unmountApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(Duration.zero);
}

void main() {
  testWidgets('tabs switch between the five main screens', (tester) async {
    final db = GrimstockDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const GrimstockApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Grimstock'), findsOneWidget);
    expect(find.text('0 / 25'), findsOneWidget);

    await tester.tap(find.text('Inventory'));
    await tester.pumpAndSettle();
    expect(find.text('No stock yet'), findsOneWidget);

    await tester.tap(find.text('Calculator'));
    await tester.pumpAndSettle();
    expect(find.text('Should I buy this?'), findsOneWidget);

    await tester.tap(find.text('Sold'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing sold yet'), findsOneWidget);

    await tester.tap(find.text('Insights').last);
    await tester.pumpAndSettle();
    expect(find.text('No insights yet'), findsOneWidget);

    await unmountApp(tester);
  });

  testWidgets('settings lists the seeded platforms', (tester) async {
    final db = GrimstockDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const GrimstockApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('StockX'), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);

    await unmountApp(tester);
  });
}
