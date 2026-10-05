# Grimstock

**By NSG Tech.** Inventory and real-profit tracking for resellers: sneakers first, anything you flip eventually.

Built with Flutter for iOS and Android. The product plan lives in the project's MVP spec; this repo follows its milestones.

## What's here (milestone 1: foundation)

- Dark "Not So Grim" theme (`lib/theme/grim_theme.dart`)
- Five tabs: Home, Inventory, Calculator, Sold, Insights, plus Settings (`lib/router.dart`)
- Offline-first local database with Drift/SQLite (`lib/data/database.dart`): items, categories with custom fields, platforms and fee presets, purchase sources, sales (the Sold archive), expenses and photos. Money is stored as integer cents; every row has a sync id for Pro cloud sync later
- Profit math with platform fees, margin and ROI (`lib/core/money.dart`)

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
