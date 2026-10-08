import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grimstock/data/database.dart';
import 'package:grimstock/data/photo_store.dart';
import 'package:grimstock/data/pro.dart';
import 'package:grimstock/data/providers.dart';
import 'package:grimstock/data/receipt_reader.dart';
import 'package:grimstock/main.dart';

class _FakePhotos extends PhotoStore {
  final deleted = <String>[];

  @override
  Future<String?> pick({
    required bool fromCamera,
    double maxSize = 1600,
    int quality = 80,
  }) async => '/fake/receipt.jpg';

  @override
  Future<void> delete(Iterable<String> paths) async => deleted.addAll(paths);
}

class _FakeReader implements ReceiptReader {
  @override
  Future<String?> read(String imagePath) async => '''
Uline
10/05/2026
Shoe boxes 30.00
Tape 10.00
Subtotal 40.00
Tax 3.30
Total 43.30
''';
}

void main() {
  testWidgets('scan a receipt, check it and save it as an expense', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2280);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final db = GrimstockDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await tester.runAsync(() => db.setSetting(devProSettingKey, 'true'));
    final photos = _FakePhotos();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          photoStoreProvider.overrideWithValue(photos),
          receiptReaderProvider.overrideWithValue(_FakeReader()),
        ],
        child: const GrimstockApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Receipts'));
    await tester.pumpAndSettle();
    expect(find.text('No receipts yet'), findsOneWidget);

    await tester.tap(find.text('Scan receipt'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Take a photo'));
    await tester.pumpAndSettle();

    // Filled in from the receipt text.
    expect(find.widgetWithText(TextFormField, 'Uline'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Shoe boxes'), findsOneWidget);
    await tester.tap(find.text('Business expense'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Save receipt'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(r'Items add up to $40.00'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '43.30'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '3.30'), findsOneWidget);
    await tester.tap(find.text('Save receipt'));
    await tester.pumpAndSettle();

    expect(find.text('Uline'), findsOneWidget);
    expect(find.text(r'$43.30'), findsOneWidget);
    expect(photos.deleted, isEmpty);
    final expenses = await tester.runAsync(() => db.select(db.expenses).get());
    expect(expenses!.single.amountCents, 4330);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  });
}
