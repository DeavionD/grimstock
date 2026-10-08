import 'package:flutter/foundation.dart';

/// Whether this build may switch Pro on without paying.
const canUseProSwitch = kDebugMode || isTestBuild;

/// What the free plan allows. Pro removes these limits.
abstract final class FreeLimits {
  static const activeItems = 25;
  static const photosPerItem = 1;
}

/// The Pro features, as listed on the paywall.
enum ProFeature {
  unlimitedItems('Unlimited active items', 'Free keeps 25 unsold items.'),
  photos('5 photos per item', 'Free gets 1.'),
  insights(
    'Full Insights',
    'Every platform, source, category and brand, with date filters.',
  ),
  listings(
    'Every listing style',
    'eBay, StockX/GOAT and Depop/Poshmark/Mercari styles.',
  ),
  expenses(
    'Expenses and mileage',
    'Supplies, subscriptions and miles come out of your profit.',
  ),
  receipts(
    'Receipt scanning',
    'Snap a receipt to save its photo, store, items, tax and total for '
        'your taxes.',
  ),
  export(
    'CSV and tax export',
    'Inventory, sales, expenses and a profit and loss summary.',
  ),
  barcodeLookup(
    'Barcode scan and deal check',
    'Scan a box to fill in the item and get a green, yellow or red buy '
        'check with its ROI.',
  ),
  customPlatforms(
    'Custom platforms',
    'Add Whatnot, local shops or anywhere else you sell.',
  );

  const ProFeature(this.title, this.detail);

  final String title;
  final String detail;
}

/// Settings key for the stand-in Pro switch used until store purchases
/// are connected (RevenueCat). Only debug and test builds can turn it on.
const devProSettingKey = 'dev_pro';

/// True for test APKs built with `--dart-define=TEST_BUILD=true`.
const isTestBuild = bool.fromEnvironment('TEST_BUILD');
