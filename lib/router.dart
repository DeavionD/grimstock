import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/calculator/calculator_screen.dart';
import 'features/home/home_screen.dart';
import 'features/insights/insights_screen.dart';
import 'features/inventory/inventory_screen.dart';
import 'features/inventory/item_detail_screen.dart';
import 'features/inventory/item_form_screen.dart';
import 'features/settings/platform_edit_screen.dart';
import 'features/settings/settings_screen.dart';
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
                  builder: (context, state) => const ItemFormScreen(),
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
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
      routes: [
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
