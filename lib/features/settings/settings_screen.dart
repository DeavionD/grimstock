import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../theme/grim_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platforms = ref.watch(platformsProvider).value ?? const [];
    final categories = ref.watch(categoriesProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Selling platforms'),
          for (final platform in platforms)
            ListTile(
              title: Text(platform.name),
              subtitle: Text(
                '${(platform.feeBasisPoints / 100).toStringAsFixed(2)}% fee',
                style: const TextStyle(color: GrimColors.ash),
              ),
            ),
          const _SectionHeader('Categories'),
          for (final category in categories)
            ListTile(title: Text(category.name)),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'Grimstock by NSG Tech',
              style: TextStyle(color: GrimColors.ash),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium
            ?.copyWith(color: GrimColors.ecto, letterSpacing: 1.2),
      ),
    );
  }
}
