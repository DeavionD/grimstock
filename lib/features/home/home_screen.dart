import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/money.dart';
import '../../data/insights.dart';
import '../../data/item_repository.dart';
import '../../data/providers.dart';
import '../../theme/grim_theme.dart';
import '../../widgets/stat_card.dart';
import '../pro/paywall_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Period _period = Period.month;

  @override
  Widget build(BuildContext context) {
    final activeCount = ref.watch(activeItemCountProvider).value ?? 0;
    final moneyInStock = ref.watch(moneyInStockProvider).value ?? 0;
    final summary = ref.watch(periodSummaryProvider(_period)).value;
    final insights = ref.watch(insightsProvider(_period)).value;
    final aging = ref.watch(agingStockProvider).value;
    final expenses = ref.watch(periodExpensesProvider(_period)).value ?? 0;
    // Real profit: sales profit minus expenses for the period.
    final profit = (summary?.profitCents ?? 0) - expenses;
    final revenue = summary?.revenueCents ?? 0;
    final margin = revenue == 0 ? null : profit / revenue * 100;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grimstock'),
        actions: [
          IconButton(
            tooltip: 'Receipts',
            icon: const Icon(Icons.document_scanner_outlined),
            onPressed: () => ref.read(isProProvider)
                ? context.push('/receipts')
                : showPaywall(context),
          ),
          IconButton(
            tooltip: 'Expenses',
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: () => ref.read(isProProvider)
                ? context.push('/expenses')
                : showPaywall(context),
          ),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final period in Period.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(period.label),
                      selected: _period == period,
                      onSelected: (_) => setState(() => _period = period),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Profit',
                  value: formatCents(profit),
                  valueColor: profit >= 0 ? GrimColors.ecto : GrimColors.blood,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(label: 'Revenue', value: formatCents(revenue)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Margin',
                  value: margin == null ? '—' : '${margin.toStringAsFixed(1)}%',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  label: 'Units sold',
                  value: '${summary?.units ?? 0}',
                ),
              ),
            ],
          ),
          if (expenses > 0) ...[
            const SizedBox(height: 12),
            StatCard(
              label: 'Expenses (taken out of profit)',
              value: formatCents(expenses),
            ),
          ],
          if (insights != null && !insights.isEmpty) ...[
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  if (insights.bestPlatform case final best?)
                    _BestRow(
                      icon: Icons.storefront_outlined,
                      label: 'Best platform',
                      name: best.name,
                      profitCents: best.profitCents,
                    ),
                  if (insights.bestCategory case final best?)
                    _BestRow(
                      icon: Icons.category_outlined,
                      label: 'Best category',
                      name: best.name,
                      profitCents: best.profitCents,
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          Text('In stock', style: text.titleMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Money in stock',
                  value: formatCents(moneyInStock),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  label: 'Active items',
                  value: ref.watch(isProProvider)
                      ? '$activeCount'
                      : '$activeCount / $freeActiveItemLimit',
                ),
              ),
            ],
          ),
          if (aging != null && aging.stale.isNotEmpty) ...[
            const SizedBox(height: 12),
            _AgingCard(aging: aging),
          ],
        ],
      ),
    );
  }
}

class _BestRow extends StatelessWidget {
  const _BestRow({
    required this.icon,
    required this.label,
    required this.name,
    required this.profitCents,
  });

  final IconData icon;
  final String label;
  final String name;
  final int profitCents;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: GrimColors.hex),
      title: Text(name),
      subtitle: Text(label, style: const TextStyle(color: GrimColors.ash)),
      trailing: Text(
        formatCents(profitCents),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: profitCents >= 0 ? GrimColors.ecto : GrimColors.blood,
        ),
      ),
    );
  }
}

/// Items that have sat unsold for 30, 60 and 90+ days, with the oldest few.
class _AgingCard extends StatelessWidget {
  const _AgingCard({required this.aging});

  final AgingStock aging;

  @override
  Widget build(BuildContext context) {
    final oldest = aging.stale.take(3).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Aging stock', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                _Bucket(label: '30–59 days', count: aging.days30to59),
                _Bucket(label: '60–89 days', count: aging.days60to89),
                _Bucket(
                  label: '90+ days',
                  count: aging.days90plus,
                  color: GrimColors.blood,
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final entry in oldest)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  entry.item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  '${entry.item.daysInStock(aging.now)} days',
                  style: TextStyle(
                    color: entry.item.daysInStock(aging.now) >= 90
                        ? GrimColors.blood
                        : GrimColors.ash,
                  ),
                ),
                onTap: () => context.go('/inventory/${entry.item.id}'),
              ),
          ],
        ),
      ),
    );
  }
}

class _Bucket extends StatelessWidget {
  const _Bucket({required this.label, required this.count, this.color});

  final String label;
  final int count;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: count > 0 ? (color ?? GrimColors.bone) : GrimColors.mist,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: GrimColors.ash, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
