import 'package:drift/drift.dart';

import '../core/money.dart';
import 'database.dart';

/// Built-in US fee presets, checked on 2026-10-05 against each platform's
/// fee page or a current fee guide. Fees change, so users can edit them in
/// Settings, and these only seed a fresh install.
///
/// - eBay: 13.6% final value fee + $0.40 per order (most categories, no store)
/// - eBay sneakers $150+: 8%, no per-order fee (Athletic Shoes category)
/// - StockX: 9% transaction fee (Seller Level 1) + 3% processing, $5 minimum
/// - GOAT: 9.5% commission + $5 seller fee + 2.9% cash-out fee
/// - Mercari: 10% selling fee, no processing fee since Jan 2025
/// - Poshmark: 20%, or a flat $2.95 on sales under $15
/// - Depop: no US selling fee, 3.3% + $0.45 payment processing
/// - Facebook Marketplace and Local / Cash: no fees for local pickup
final defaultPlatformPresets = <PlatformsCompanion>[
  PlatformsCompanion.insert(
    name: 'eBay',
    feeBasisPoints: const Value(1360),
    fixedFeeCents: const Value(40),
    note: const Value('Most categories, no store'),
  ),
  PlatformsCompanion.insert(
    name: r'eBay sneakers $150+',
    feeBasisPoints: const Value(800),
    note: const Value('Athletic shoes sold for \$150 or more'),
  ),
  PlatformsCompanion.insert(
    name: 'StockX',
    feeBasisPoints: const Value(900),
    processingBasisPoints: const Value(300),
    minimumFeeCents: const Value(500),
    note: const Value('Seller Level 1'),
  ),
  PlatformsCompanion.insert(
    name: 'GOAT',
    feeBasisPoints: const Value(950),
    fixedFeeCents: const Value(500),
    processingBasisPoints: const Value(290),
    note: const Value('Includes 2.9% cash-out fee'),
  ),
  PlatformsCompanion.insert(name: 'Mercari', feeBasisPoints: const Value(1000)),
  PlatformsCompanion.insert(
    name: 'Poshmark',
    feeBasisPoints: const Value(2000),
    smallSaleThresholdCents: const Value(1500),
    smallSaleFlatFeeCents: const Value(295),
    note: const Value('Flat \$2.95 under \$15'),
  ),
  PlatformsCompanion.insert(
    name: 'Depop',
    processingBasisPoints: const Value(330),
    fixedFeeCents: const Value(45),
    note: const Value('No US selling fee, processing only'),
  ),
  PlatformsCompanion.insert(
    name: 'Facebook Marketplace',
    note: const Value('Local pickup'),
  ),
  PlatformsCompanion.insert(name: 'Local / Cash'),
];

extension PlatformFees on Platform {
  FeeRule get feeRule => FeeRule(
    percentBasisPoints: feeBasisPoints,
    fixedCents: fixedFeeCents,
    processingBasisPoints: processingBasisPoints,
    minimumFeeCents: minimumFeeCents,
    smallSaleThresholdCents: smallSaleThresholdCents,
    smallSaleFlatFeeCents: smallSaleFlatFeeCents,
  );

  /// One-line summary like "13.6% + $0.40".
  String get feeSummary {
    final parts = <String>[];
    final percent = feeBasisPoints + processingBasisPoints;
    if (percent > 0) parts.add(formatBasisPoints(percent));
    if (fixedFeeCents > 0) parts.add(formatCents(fixedFeeCents));
    if (parts.isEmpty) return 'No fees';
    var summary = parts.join(' + ');
    if (minimumFeeCents > 0) summary += ', ${formatCents(minimumFeeCents)} min';
    return summary;
  }
}
