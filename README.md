# Grimstock

**By NSG Tech.** Inventory and real-profit tracking for resellers: sneakers first, anything you flip eventually.

Built with Flutter for iOS and Android. The product plan lives in the project's MVP spec; this repo follows its milestones.

## What's here (milestone 1: foundation)

- Dark "Not So Grim" theme (`lib/theme/grim_theme.dart`)
- Five tabs: Home, Inventory, Calculator, Sold, Insights, plus Settings (`lib/router.dart`)
- Offline-first local database with Drift/SQLite (`lib/data/database.dart`): items, categories with custom fields, platforms and fee presets, purchase sources, sales (the Sold archive), expenses and photos. Money is stored as integer cents; every row has a sync id for Pro cloud sync later
- Profit math with platform fees, margin and ROI (`lib/core/money.dart`)

## Milestone 2: inventory and profit

- Add, edit, duplicate and delete items, with barcode scanning for the SKU (`lib/features/inventory/`)
- Inventory list with search, status filters and sorting
- Item detail with a "What would I make?" profit estimate per platform
- Free plan limit of 25 active items, enforced in `lib/data/item_repository.dart`
- US fee presets for eBay, StockX, GOAT, Mercari, Poshmark and Depop (`lib/data/platform_presets.dart`), editable in Settings

## Milestone 3: selling and the Sold archive

- "Mark as sold" from any item: platform, sale price, fees filled from the platform's preset, shipping, packaging and tracking. Selling part of a multi-unit item lowers its quantity (`lib/data/sales_repository.dart`)
- Each sale keeps a snapshot of the item's cost, so later edits don't rewrite past profit
- Sold tab: every sale with where it was bought and where it sold, search, a platform filter and totals. Sale details show the full breakdown, mark shipped, and undo a sale recorded by mistake
- Calculator tab: enter a buy price and expected sale price to rank every platform by profit, then add the item to inventory with its costs filled in
- Up to 5 photos per item, from the camera or library, stored on the device (`lib/data/photo_store.dart`)
- Home shows this month's profit and revenue

## Milestone 4: dashboard, Insights and listings

- Home dashboard for this week, month, year or all time: profit, revenue, margin and units sold, plus the best platform and category
- Aging stock: active items unsold for 30, 60 and 90+ days, with the oldest listed
- Insights tab built from the Sold archive (`lib/data/insights.dart`): where you sell best (by profit, items sold, speed or fees), best places to buy by return, best categories and brands, and the slowest movers
- Listing writer on each item (`lib/data/listing_writer.dart`): a title and description in Standard, eBay, StockX/GOAT or Depop/Poshmark/Mercari style, editable and one tap to copy. Templates run on the phone, so it works offline and costs nothing

## Milestone 5: Pro, expenses, export and barcode autofill

- Free plan limits (`lib/data/pro.dart`): 25 active items, 1 photo per item, top platform and source in Insights, the standard listing style. Pro lifts them, shown on a paywall ($3.99/month or $34.99/year)
- Store purchases (RevenueCat) aren't connected yet. Debug and test builds have a "Pro (test build)" switch in Settings to try every Pro feature
- Expenses and mileage (`lib/data/expense_repository.dart`), taken out of dashboard profit. Mileage uses the IRS 2026 rate of 72.5¢ a mile, editable in Settings
- CSV export of inventory, sales and expenses, plus a profit and loss summary for a tax year (`lib/data/export.dart`)
- Barcode autofill: scanning a UPC fills in the name and brand from UPCitemdb's free trial (100 lookups a day; needs a paid key before launch)

## Tester feedback (round 1)

- Appliances category with Model and Serial number fields. Existing installs get it through a database migration (schema version 2)
- Sales tax by state on the item form: the calculator icon on the Tax field picks a state (Tax Foundation 2026 average combined rates, editable) and works out the tax (`lib/data/sales_tax.dart`)
- Calculator "What to list for": enter what you paid and the profit or ROI you want, and see the lowest list price on every platform after fees (`listPriceFor` in `lib/data/deal_check.dart`)
- Pro deal check: scan a barcode in the Calculator to look up the product, then get a green (good buy), yellow (buy at your own risk) or red (not worth it) check from the ROI and how fast you've sold that item before. It uses your own Sold archive for now; market-wide sold prices need a paid data source later

## Test APK

Every push to `main` and every pull request builds an Android APK with the Pro test switch (`.github/workflows/test-apk.yml`). Download `grimstock-test-apk` from the workflow run's Artifacts, unzip it, and install `app-release.apk` on an Android phone (allow installs from your browser or files app when asked).

To build one locally:

```sh
flutter build apk --release --dart-define=TEST_BUILD=true
```

## Getting started

```sh
flutter pub get
flutter run
```

After changing a table in `lib/data/database.dart`, regenerate the database code:

```sh
dart run build_runner build
```

## Checks

```sh
flutter analyze
flutter test
```

Both run automatically on every pull request.
