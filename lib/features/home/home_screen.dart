import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/money.dart';
import '../../data/providers.dart';
import '../../theme/grim_theme.dart';
import '../../widgets/stat_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCount = ref.watch(activeItemCountProvider).value ?? 0;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grimstock'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('This month', style: text.titleMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Profit',
                  value: formatCents(0),
                  valueColor: GrimColors.ecto,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(label: 'Revenue', value: formatCents(0)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(label: 'Money in stock', value: formatCents(0)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  label: 'Active items',
                  value: '$activeCount / $freeActiveItemLimit',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
