import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/pro.dart';
import '../../data/providers.dart';
import '../../theme/grim_theme.dart';

/// Opens the Pro paywall.
void showPaywall(BuildContext context) => context.push('/pro');

/// What Pro unlocks and what it costs.
class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = ref.watch(isProProvider);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          const Icon(Icons.auto_awesome, size: 48, color: GrimColors.ecto),
          const SizedBox(height: 12),
          Text(
            isPro ? 'You have Grimstock Pro' : 'Grimstock Pro',
            style: text.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Everything you need once your stock outgrows the free plan.',
            style: text.bodyMedium?.copyWith(color: GrimColors.ash),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          for (final feature in ProFeature.values)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.check_circle, color: GrimColors.ecto),
              title: Text(feature.title),
              subtitle: Text(
                feature.detail,
                style: const TextStyle(color: GrimColors.ash),
              ),
            ),
          const SizedBox(height: 16),
          if (!isPro) ...[
            const _PlanCard(
              title: 'Yearly',
              price: r'$34.99 / year',
              note: r'About $2.92 a month, 27% off',
              best: true,
            ),
            const SizedBox(height: 8),
            const _PlanCard(title: 'Monthly', price: r'$3.99 / month'),
            const SizedBox(height: 16),
            FilledButton(
              // Store purchases are connected once the App Store, Google
              // Play and RevenueCat accounts exist. Debug builds can use the
              // stand-in switch to try Pro features.
              onPressed: canUseProSwitch
                  ? () => ref
                        .read(databaseProvider)
                        .setSetting(devProSettingKey, 'true')
                  : null,
              child: Text(
                canUseProSwitch ? 'Try Pro (test build)' : 'Coming soon',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.price,
    this.note,
    this.best = false,
  });

  final String title;
  final String price;
  final String? note;
  final bool best;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: best ? GrimColors.ecto : GrimColors.mist),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  if (note != null)
                    Text(
                      note!,
                      style: const TextStyle(
                        color: GrimColors.ecto,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            Text(price, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

/// A row saying a feature needs Pro, opening the paywall when tapped.
class ProLockTile extends StatelessWidget {
  const ProLockTile({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.lock_outline, color: GrimColors.hex),
      title: Text(title),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, style: const TextStyle(color: GrimColors.ash)),
      trailing: const Text(
        'PRO',
        style: TextStyle(
          color: GrimColors.ecto,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
      onTap: () => showPaywall(context),
    );
  }
}
