import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/platform_presets.dart';
import '../../data/providers.dart';
import '../../theme/grim_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _addPlatform(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a platform'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. Whatnot'),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty) return;
    final id = await ref.read(databaseProvider).addPlatform(name);
    if (context.mounted) context.push('/settings/platforms/$id');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platforms = ref.watch(platformsProvider).value ?? const [];
    final categories = ref.watch(categoriesProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Selling platforms and fees'),
          for (final platform in platforms)
            ListTile(
              title: Text(platform.name),
              subtitle: Text(
                [
                  platform.feeSummary,
                  if (platform.note != null) platform.note!,
                ].join(' · '),
                style: const TextStyle(color: GrimColors.ash),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/platforms/${platform.id}'),
            ),
          ListTile(
            leading: const Icon(Icons.add, color: GrimColors.ecto),
            title: const Text('Add a platform'),
            onTap: () => _addPlatform(context, ref),
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
