import 'package:intl/intl.dart';

/// All money in Grimstock is stored as integer cents to avoid float rounding.
typedef Cents = int;

final _usd = NumberFormat.simpleCurrency(name: 'USD');

String formatCents(Cents cents) => _usd.format(cents / 100);

/// Parses user input like "120", "120.5" or "$1,299.99" into cents.
/// Returns null for anything that isn't a valid amount.
Cents? parseCents(String input) {
  final cleaned = input.replaceAll(RegExp(r'[\s$,]'), '');
  if (cleaned.isEmpty) return null;
  final match = RegExp(r'^(-?)(\d*)(?:\.(\d{0,2}))?$').firstMatch(cleaned);
  if (match == null) return null;
  final whole = match.group(2)!;
  final fraction = match.group(3) ?? '';
  if (whole.isEmpty && fraction.isEmpty) return null;
  final cents =
      int.parse(whole.isEmpty ? '0' : whole) * 100 +
      int.parse(fraction.padRight(2, '0'));
  return match.group(1) == '-' ? -cents : cents;
}

/// A platform's selling fees: a percentage of the sale price, a fixed fee
/// per order, and an optional payment processing percentage.
class FeeRule {
  const FeeRule({
    this.percentBasisPoints = 0,
    this.fixedCents = 0,
    this.processingBasisPoints = 0,
  });

  /// Commission in basis points (1250 = 12.5%).
  final int percentBasisPoints;
  final Cents fixedCents;

  /// Payment processing in basis points, charged on the sale price.
  final int processingBasisPoints;

  Cents feesFor(Cents salePrice) {
    final percent = salePrice * (percentBasisPoints + processingBasisPoints);
    return (percent / 10000).round() + fixedCents;
  }
}

/// Everything that goes into one item's real profit.
class ProfitInput {
  const ProfitInput({
    required this.purchasePrice,
    required this.salePrice,
    this.purchaseTax = 0,
    this.inboundShipping = 0,
    this.otherCosts = 0,
    this.fees = const FeeRule(),
    this.outboundShipping = 0,
    this.packaging = 0,
  });

  final Cents purchasePrice;
  final Cents purchaseTax;
  final Cents inboundShipping;
  final Cents otherCosts;
  final Cents salePrice;
  final FeeRule fees;
  final Cents outboundShipping;
  final Cents packaging;
}

class ProfitResult {
  const ProfitResult({
    required this.totalCost,
    required this.platformFees,
    required this.netProfit,
    required this.marginPercent,
    required this.roiPercent,
  });

  /// What it cost to buy and get the item in hand.
  final Cents totalCost;
  final Cents platformFees;
  final Cents netProfit;

  /// Net profit as a percentage of the sale price. Null when nothing sold.
  final double? marginPercent;

  /// Net profit as a percentage of total cost. Null when the item was free.
  final double? roiPercent;
}

ProfitResult calculateProfit(ProfitInput input) {
  final totalCost =
      input.purchasePrice +
      input.purchaseTax +
      input.inboundShipping +
      input.otherCosts;
  final platformFees = input.fees.feesFor(input.salePrice);
  final netProfit =
      input.salePrice -
      platformFees -
      input.outboundShipping -
      input.packaging -
      totalCost;
  return ProfitResult(
    totalCost: totalCost,
    platformFees: platformFees,
    netProfit: netProfit,
    marginPercent: input.salePrice == 0
        ? null
        : netProfit / input.salePrice * 100,
    roiPercent: totalCost == 0 ? null : netProfit / totalCost * 100,
  );
}
