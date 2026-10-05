import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grimstock/data/database.dart';
import 'package:grimstock/data/pro.dart';
import 'package:grimstock/data/providers.dart';
import 'package:grimstock/main.dart';

void main() {
  late GrimstockDatabase db;

  Future<void> startApp(WidgetTester tester, {bool pro = false}) async {
    tester.view.physicalSize = const Size(1080, 2280);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    db = GrimstockDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    if (pro) {
      await tester.runAsync(() => db.setSetting(devProSettingKey, 'true'));
    }
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const GrimstockApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  }

  testWidgets('free users see the paywall for expenses', (tester) async {
    await startApp(tester);
    await tester.tap(find.byTooltip('Expenses'));
    await tester.pumpAndSettle();
    expect(find.text('Grimstock Pro'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(r'$34.99 / year'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Try Pro (test build)'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('log mileage and see it come out of profit', (tester) async {
    await startApp(tester, pro: true);
    // Pro shows the item count without a cap.
    expect(find.text('0 / 25'), findsNothing);

    await tester.tap(find.byTooltip('Expenses'));
    await tester.pumpAndSettle();
    expect(find.text('No expenses yet'), findsOneWidget);

    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Supplies'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mileage').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Miles'), '40');
    await tester.pumpAndSettle();
    expect(find.text(r'$29.00 at 72.5¢ a mile'), findsOneWidget);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text(r'$29.00'), findsOneWidget);
    expect(find.text('This month: \$29.00'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text(r'-$29.00'), findsOneWidget);
    expect(find.text('Expenses (taken out of profit)'), findsOneWidget);

    await unmount(tester);
  });
}
