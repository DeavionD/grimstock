import 'package:flutter_test/flutter_test.dart';
import 'package:grimstock/core/money.dart';
import 'package:grimstock/data/database.dart';
import 'package:grimstock/data/deal_check.dart';
import 'package:grimstock/data/sales_repository.dart';
import 'package:grimstock/data/sales_tax.dart';

void main() {
  group('listPriceFor', () {
    const poshmark = FeeRule(
      percentBasisPoints: 2000,
      smallSaleThresholdCents: 1500,
      smallSaleFlatFeeCents: 295,
    );

    int profitAt(FeeRule fees, int price) => calculateProfit(
      ProfitInput(
        purchasePrice: 10000,
        salePrice: price,
        fees: fees,
        outboundShipping: 1000,
      ),
    ).netProfit;

    test('is the lowest price that covers cost, fees and the target', () {
      const ebay = FeeRule(percentBasisPoints: 1360, fixedCents: 40);
      final price = listPriceFor(
        ebay,
        costCents: 10000,
        targetProfitCents: 5000,
        outboundShippingCents: 1000,
      )!;
      expect(profitAt(ebay, price), greaterThanOrEqualTo(5000));
      expect(profitAt(ebay, price - 1), lessThan(5000));
    });

    test('uses the small-sale flat fee when it is cheaper', () {
      expect(
        listPriceFor(poshmark, costCents: 0, targetProfitCents: 1000),
        1295,
      );
      // $14.95 under the flat fee beats $15.00 at 20%.
      expect(
        listPriceFor(poshmark, costCents: 0, targetProfitCents: 1200),
        1495,
      );
      expect(
        listPriceFor(poshmark, costCents: 0, targetProfitCents: 1210),
        1512, // 20% of $15.12 rounds to $3.02
      );
    });

    test('respects a minimum fee', () {
      const stockx = FeeRule(
        percentBasisPoints: 900,
        processingBasisPoints: 300,
        minimumFeeCents: 500,
      );
      expect(listPriceFor(stockx, costCents: 0, targetProfitCents: 1000), 1500);
    });
  });

  group('checkDeal', () {
    test('green for a strong return with no slow history', () {
      final check = checkDeal(totalCostCents: 10000, bestProfitCents: 4000);
      expect(check.verdict, DealVerdict.good);
    });

    test('yellow for a thin return or a slow mover', () {
      expect(
        checkDeal(totalCostCents: 10000, bestProfitCents: 2000).verdict,
        DealVerdict.risky,
      );
      const slow = PriceHistory(
        sales: 2,
        averageUnitPriceCents: 20000,
        medianDaysToSell: 90,
      );
      final check = checkDeal(
        totalCostCents: 10000,
        bestProfitCents: 6000,
        history: slow,
      );
      expect(check.verdict, DealVerdict.risky);
      expect(check.reasons, contains('Slow mover: money sits in stock'));
    });

    test('red for a loss or a tiny return', () {
      expect(
        checkDeal(totalCostCents: 10000, bestProfitCents: -100).verdict,
        DealVerdict.pass,
      );
      expect(
        checkDeal(totalCostCents: 10000, bestProfitCents: 1000).verdict,
        DealVerdict.pass,
      );
    });
  });

  test('priceHistoryFor matches by barcode, then by name', () {
    final now = DateTime(2026, 10, 6);
    SoldEntry entry(String name, String? sku, int price, int days) => SoldEntry(
      sale: Sale(
        id: 1,
        syncId: 's',
        createdAt: now,
        updatedAt: now,
        itemId: 1,
        soldAt: now,
        quantity: 1,
        unitCostCents: 10000,
        salePriceCents: price,
        platformFeesCents: 0,
        outboundShippingCents: 0,
        packagingCents: 0,
      ),
      item: Item(
        id: 1,
        syncId: 'i',
        createdAt: now,
        updatedAt: now,
        name: name,
        sku: sku,
        quantity: 1,
        status: ItemStatus.sold,
        purchaseDate: now.subtract(Duration(days: days)),
        purchasePriceCents: 10000,
        purchaseTaxCents: 0,
        inboundShippingCents: 0,
        otherCostsCents: 0,
      ),
    );
    final sold = [
      entry('Jordan 4 Bred', '195244', 20000, 10),
      entry('Jordan 4 Bred', '195244', 30000, 30),
      entry('Dunk Low Panda', null, 15000, 5),
    ];

    final byCode = priceHistoryFor(sold, barcode: '195244')!;
    expect(byCode.sales, 2);
    expect(byCode.averageUnitPriceCents, 25000);
    expect(byCode.medianDaysToSell, 30);

    final byName = priceHistoryFor(
      sold,
      barcode: '000',
      name: 'dunk low panda',
    );
    expect(byName!.averageUnitPriceCents, 15000);
    expect(priceHistoryFor(sold, barcode: '000'), isNull);
  });

  test('sales tax by state', () {
    expect(StateSalesTax.taxOn(10000, 946), 946);
    expect(StateSalesTax.taxOn(1999, 825), 165);
    expect(stateSalesTaxes, hasLength(51));
    expect(stateSalesTax('CA')!.stateBasisPoints, 725);
  });
}
