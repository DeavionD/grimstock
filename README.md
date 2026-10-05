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
