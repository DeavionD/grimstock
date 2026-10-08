import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/calculator/calculator_screen.dart';
import 'features/expenses/expense_form_screen.dart';
import 'features/expenses/expenses_screen.dart';
import 'features/home/home_screen.dart';
import 'features/insights/insights_screen.dart';
import 'features/inventory/inventory_screen.dart';
import 'features/inventory/item_detail_screen.dart';
import 'features/inventory/item_form_screen.dart';
import 'features/inventory/sell_screen.dart';
import 'features/pro/paywall_screen.dart';
import 'features/receipts/receipt_form_screen.dart';
import 'features/receipts/receipts_screen.dart';
import 'features/settings/export_screen.dart';
import 'features/settings/platform_edit_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/sold/sale_detail_screen.dart';
import 'features/sold/sold_screen.dart';

GoRouter createRouter() => GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _TabShell(shell: shell),
      branches: [
        _tab('/home', const HomeScreen()),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inventory',
              builder: (context, state) => const InventoryScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  builder: (context, state) => ItemFormScreen(
                    prefill: state.extra is ItemPrefill
                        ? state.extra! as ItemPrefill
                        : null,
                  ),
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) =>
                      ItemDetailScreen(itemId: _id(state)),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      builder: (context, state) =>
                          ItemFormScreen(itemId: _id(state)),
                    ),
                    GoRoute(
                      path: 'sell',
                      builder: (context, state) =>
                          SellScreen(itemId: _id(state)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        _tab('/calculator', const CalculatorScreen()),
        _tab('/sold', const SoldScreen()),
        _tab('/insights', const InsightsScreen()),
      ],
    ),
    // Outside the tab shell so both Inventory and Sold can open it.
    GoRoute(
      path: '/sales/:id',
      builder: (context, state) => SaleDetailScreen(saleId: _id(state)),
    ),
    GoRoute(
      path: '/expenses',
      builder: (context, state) => const ExpensesScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const ExpenseFormScreen(),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) => ExpenseFormScreen(expenseId: _id(state)),
        ),
      ],
    ),
    GoRoute(
      path: '/receipts',
      builder: (context, state) => const ReceiptsScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => ReceiptFormScreen(
            photoPath: state.extra is String ? state.extra! as String : null,
          ),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) => ReceiptFormScreen(receiptId: _id(state)),
        ),
      ],
    ),
    GoRoute(path: '/pro', builder: (context, state) => const PaywallScreen()),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
      routes: [
        GoRoute(
          path: 'export',
          builder: (context, state) => const ExportScreen(),
        ),
        GoRoute(
          path: 'platforms/:id',
          builder: (context, state) =>
              PlatformEditScreen(platformId: _id(state)),
        ),
      ],
    ),
  ],
);

int _id(GoRouterState state) => int.parse(state.pathParameters['id']!);

StatefulShellBranch _tab(String path, Widget screen) => StatefulShellBranch(
  routes: [GoRoute(path: path, builder: (context, state) => screen)],
);

class _TabShell extends StatelessWidget {
  const _TabShell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (index) =>
            shell.goBranch(index, initialLocation: index == shell.currentIndex),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          NavigationDestination(
            icon: Icon(Icons.archive_outlined),
            selectedIcon: Icon(Icons.archive),
            label: 'Sold',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Insights',
          ),
        ],
      ),
    );
  }
}
