import '../core/money.dart';
import 'sales_repository.dart';

/// How past sales of the same item went, from the user's own Sold archive.
class PriceHistory {
  const PriceHistory({
    required this.sales,
    required this.averageUnitPriceCents,
    required this.medianDaysToSell,
    this.averageRoiPercent,
  });

  final int sales;
  final int averageUnitPriceCents;
  final int medianDaysToSell;
  final double? averageRoiPercent;
}

/// Past sales of the item with this barcode, or with this name when the
/// barcode doesn't match any. Null when there are none.
PriceHistory? priceHistoryFor(
  List<SoldEntry> sold, {
  String? barcode,
  String? name,
}) {
  final code = barcode?.trim() ?? '';
  final title = name?.trim().toLowerCase() ?? '';
  var matches = code.isEmpty
      ? <SoldEntry>[]
      : sold.where((e) => e.item.sku?.trim() == code).toList();
  if (matches.isEmpty && title.isNotEmpty) {
    matches = sold
        .where((e) => e.item.name.trim().toLowerCase() == title)
        .toList();
  }
  if (matches.isEmpty) return null;

  var units = 0;
  var revenue = 0;
  final rois = <double>[];
  for (final e in matches) {
    units += e.sale.quantity;
    revenue += e.sale.salePriceCents;
    final roi = e.sale.roiPercent;
    if (roi != null) rois.add(roi);
  }
  final days = matches.map((e) => e.daysToSell).toList()..sort();
  return PriceHistory(
    sales: matches.length,
    averageUnitPriceCents: units == 0 ? 0 : (revenue / units).round(),
    medianDaysToSell: days[days.length ~/ 2],
    averageRoiPercent: rois.isEmpty
        ? null
        : rois.reduce((a, b) => a + b) / rois.length,
  );
}

enum DealVerdict {
  good('Looks like a good buy'),
  risky('Buy at your own risk'),
  pass('Not worth it');

  const DealVerdict(this.label);

  final String label;
}

class DealCheck {
  const DealCheck(this.verdict, this.reasons);

  final DealVerdict verdict;
  final List<String> reasons;
}

/// Return on cost below this is not worth the time.
const minimumRoiPercent = 15.0;

/// Return on cost at or above this is a good buy (if it moves).
const goodRoiPercent = 30.0;

/// Items that usually take longer than this to sell are risky.
const slowSaleDays = 45;

/// Green, yellow or red for buying at [totalCostCents] and selling for
/// [bestProfitCents] profit on the best platform. [history] adds how fast
/// this item has sold before.
DealCheck checkDeal({
  required int totalCostCents,
  required int bestProfitCents,
  PriceHistory? history,
}) {
  final reasons = <String>[];
  final roi = totalCostCents == 0
      ? null
      : bestProfitCents / totalCostCents * 100;
  final roiText = roi == null ? '' : ' (${roi.toStringAsFixed(0)}% ROI)';
  reasons.add(
    '${formatCents(bestProfitCents)} profit on the best platform$roiText',
  );

  final slow = history != null && history.medianDaysToSell > slowSaleDays;
  if (history != null) {
    final times = history.sales == 1 ? 'once' : '${history.sales} times';
    reasons.add(
      'You sold this $times, usually in ${history.medianDaysToSell} days',
    );
  } else {
    reasons.add('No sales of this item yet, so how fast it moves is unknown');
  }

  final DealVerdict verdict;
  if (bestProfitCents <= 0 || (roi != null && roi < minimumRoiPercent)) {
    verdict = DealVerdict.pass;
  } else if (slow || (roi != null && roi < goodRoiPercent)) {
    verdict = DealVerdict.risky;
    if (slow) reasons.add('Slow mover: money sits in stock');
  } else {
    verdict = DealVerdict.good;
  }
  return DealCheck(verdict, reasons);
}

/// The lowest sale price on a platform with [fees] that makes at least
/// [targetProfitCents] after fees, shipping, packaging and [costCents].
/// Null when no price under $100,000 gets there.
int? listPriceFor(
  FeeRule fees, {
  required int costCents,
  required int targetProfitCents,
  int outboundShippingCents = 0,
  int packagingCents = 0,
}) {
  int profit(int price) =>
      price -
      fees.feesFor(price) -
      outboundShippingCents -
      packagingCents -
      costCents;

  // Profit rises with price, except where a small-sale flat fee switches to
  // the regular percentage. Search each side of that threshold on its own.
  int? lowest(int from, int to) {
    if (to < from || profit(to) < targetProfitCents) return null;
    var lo = from;
    var hi = to;
    while (lo < hi) {
      final mid = (lo + hi) ~/ 2;
      if (profit(mid) >= targetProfitCents) {
        hi = mid;
      } else {
        lo = mid + 1;
      }
    }
    return lo;
  }

  const ceiling = 10000000;
  final threshold = fees.smallSaleThresholdCents;
  if (threshold > 1) {
    final below = lowest(1, threshold - 1);
    if (below != null) return below;
  }
  return lowest(threshold > 1 ? threshold : 1, ceiling);
}
