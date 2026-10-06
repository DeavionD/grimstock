import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/expense_repository.dart';
import '../../data/platform_presets.dart';
import '../../data/pro.dart';
import '../../data/providers.dart';
import '../../theme/grim_theme.dart';
import '../pro/paywall_screen.dart';

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

  Future<void> _editMileageRate(BuildContext context, WidgetRef ref) async {
    final current =
        ref.read(mileageRateProvider).value ?? defaultMileageRateCents;
    final controller = TextEditingController(text: '$current');
    final value = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mileage rate'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            suffixText: '¢ a mile',
            helperText: 'The IRS 2026 business rate is 72.5¢',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(double.tryParse(controller.text)),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value != null && value > 0) {
      await ref.read(expenseRepositoryProvider).setMileageRate(value);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platforms = ref.watch(platformsProvider).value ?? const [];
    final isPro = ref.watch(isProProvider);
    final categories = ref.watch(categoriesProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Plan'),
          ListTile(
            leading: Icon(
              Icons.auto_awesome,
              color: isPro ? GrimColors.ecto : GrimColors.hex,
            ),
            title: Text(isPro ? 'Grimstock Pro' : 'Free plan'),
            subtitle: Text(
              isPro
                  ? 'Everything is unlocked'
                  : '${FreeLimits.activeItems} active items, 1 photo each',
              style: const TextStyle(color: GrimColors.ash),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showPaywall(context),
          ),
          // Stand-in until store purchases are connected. Debug and test builds only.
          if (canUseProSwitch)
            SwitchListTile(
              title: const Text('Pro (test build)'),
              subtitle: const Text(
                'Turns Pro on without paying, for testing',
                style: TextStyle(color: GrimColors.ash),
              ),
              value: isPro,
              onChanged: (on) => ref
                  .read(databaseProvider)
                  .setSetting(devProSettingKey, '$on'),
            ),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: const Text('Expenses and mileage'),
            trailing: isPro ? const Icon(Icons.chevron_right) : const _ProTag(),
            onTap: () =>
                isPro ? context.push('/expenses') : showPaywall(context),
          ),
          if (isPro)
            ListTile(
              leading: const Icon(Icons.directions_car_outlined),
              title: const Text('Mileage rate'),
              subtitle: Text(
                '${ref.watch(mileageRateProvider).value ?? defaultMileageRateCents}¢ a mile',
                style: const TextStyle(color: GrimColors.ash),
              ),
              onTap: () => _editMileageRate(context, ref),
            ),
          ListTile(
            leading: const Icon(Icons.file_download_outlined),
            title: const Text('Export to CSV'),
            trailing: isPro ? const Icon(Icons.chevron_right) : const _ProTag(),
            onTap: () =>
                isPro ? context.push('/settings/export') : showPaywall(context),
          ),
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
            trailing: isPro ? null : const _ProTag(),
            onTap: () =>
                isPro ? _addPlatform(context, ref) : showPaywall(context),
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

class _ProTag extends StatelessWidget {
  const _ProTag();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'PRO',
      style: TextStyle(
        color: GrimColors.ecto,
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
      ),
    );
  }
}
