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
