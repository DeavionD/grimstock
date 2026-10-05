import 'package:flutter_test/flutter_test.dart';
import 'package:grimstock/core/money.dart';

void main() {
  group('parseCents', () {
    test('reads whole and decimal amounts', () {
      expect(parseCents('120'), 12000);
      expect(parseCents('120.5'), 12050);
      expect(parseCents(r'$1,299.99'), 129999);
      expect(parseCents('.75'), 75);
      expect(parseCents('-5'), -500);
    });

    test('rejects junk', () {
      expect(parseCents(''), isNull);
      expect(parseCents('abc'), isNull);
      expect(parseCents('1.234'), isNull);
      expect(parseCents('.'), isNull);
    });
  });

  group('calculateProfit', () {
    test('subtracts costs, fees and shipping', () {
      final result = calculateProfit(
        const ProfitInput(
          purchasePrice: 11000,
          purchaseTax: 880,
          salePrice: 20000,
          fees: FeeRule(percentBasisPoints: 900, processingBasisPoints: 300),
          outboundShipping: 1500,
        ),
      );
      expect(result.totalCost, 11880);
      expect(result.platformFees, 2400);
      expect(result.netProfit, 20000 - 2400 - 1500 - 11880);
      expect(result.marginPercent, closeTo(21.1, 0.01));
      expect(result.roiPercent, closeTo(35.52, 0.01));
    });

    test('adds fixed fees and handles a loss', () {
      final result = calculateProfit(
        const ProfitInput(
          purchasePrice: 5000,
          salePrice: 4000,
          fees: FeeRule(percentBasisPoints: 1000, fixedCents: 30),
        ),
      );
      expect(result.platformFees, 430);
      expect(result.netProfit, -1430);
    });

    test('leaves margin and ROI empty when they would divide by zero', () {
      final result = calculateProfit(
        const ProfitInput(purchasePrice: 0, salePrice: 0),
      );
      expect(result.marginPercent, isNull);
      expect(result.roiPercent, isNull);
    });
  });

  group('FeeRule', () {
    test('applies a minimum total fee', () {
      const stockx = FeeRule(
        percentBasisPoints: 900,
        processingBasisPoints: 300,
        minimumFeeCents: 500,
      );
      expect(stockx.feesFor(10000), 1200);
      expect(stockx.feesFor(3000), 500);
    });

    test('uses the flat fee for small sales', () {
      const poshmark = FeeRule(
        percentBasisPoints: 2000,
        smallSaleThresholdCents: 1500,
        smallSaleFlatFeeCents: 295,
      );
      expect(poshmark.feesFor(1400), 295);
      expect(poshmark.feesFor(1500), 300);
      expect(poshmark.feesFor(5000), 1000);
    });

    test('charges nothing when nothing sold', () {
      expect(const FeeRule(fixedCents: 40).feesFor(0), 0);
    });
  });

  test('formats and parses percents', () {
    expect(formatBasisPoints(1360), '13.6%');
    expect(formatBasisPoints(900), '9%');
    expect(formatBasisPoints(1275), '12.75%');
    expect(parseBasisPoints('9.5%'), 950);
    expect(parseBasisPoints('-1'), isNull);
  });
}
