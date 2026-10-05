import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/money.dart';
import '../../data/insights.dart';
import '../../data/providers.dart';
import '../../theme/grim_theme.dart';
import '../../widgets/empty_state.dart';
import '../pro/paywall_screen.dart';

/// How to rank platforms in the "Where you sell best" card.
enum PlatformRank {
  profit('Profit'),
  sold('Items sold'),
  speed('Fastest'),
  fees('Lowest fees');

  const PlatformRank(this.label);

  final String label;

  List<GroupStats> sort(List<GroupStats> platforms) {
    final sorted = [...platforms];
    switch (this) {
      case PlatformRank.profit:
        break; // Already by profit.
      case PlatformRank.sold:
        sorted.sort((a, b) => b.units.compareTo(a.units));
      case PlatformRank.speed:
        sorted.sort(
          (a, b) => a.averageDaysToSell.compareTo(b.averageDaysToSell),
        );
      case PlatformRank.fees:
        sorted.sort((a, b) => a.averageFeesCents.compareTo(b.averageFeesCents));
    }
    return sorted;
  }
}

/// What the Sold archive says: where you sell best, where to buy, what
/// earns the most, and what sits longest.
class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  Period _period = Period.allTime;
  PlatformRank _rank = PlatformRank.profit;

  @override
  Widget build(BuildContext context) {
    final insights = ref.watch(insightsProvider(_period)).value;
    final isPro = ref.watch(isProProvider);
    final anySales = (ref.watch(allSoldProvider).value ?? const []).isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: insights == null
          ? const SizedBox.shrink()
          : !anySales
          ? const EmptyState(
              icon: Icons.insights_outlined,
              title: 'No insights yet',
              message:
                  'Once you sell a few items, this shows your best platforms, '
                  'best places to buy, and what sells fastest.',
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final period in Period.values.reversed)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(period.label),
                            selected: _period == period,
                            onSelected: (_) {
                              // Date filters are a Pro feature.
                              if (!isPro && period != Period.allTime) {
                                showPaywall(context);
                                return;
                              }
                              setState(() => _period = period);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (insights.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Text(
                      'No sales in this period.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: GrimColors.ash),
                    ),
                  )
                else ...[
                  _Section(
                    title: 'Where you sell best',
                    trailing: !isPro
                        ? null
                        : PopupMenuButton<PlatformRank>(
                            tooltip: 'Rank by',
                            initialValue: _rank,
                            onSelected: (rank) => setState(() => _rank = rank),
                            itemBuilder: (context) => [
                              for (final rank in PlatformRank.values)
                                PopupMenuItem(
                                  value: rank,
                                  child: Text(rank.label),
                                ),
                            ],
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _rank.label,
                                  style: const TextStyle(color: GrimColors.hex),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: GrimColors.hex,
                                ),
                              ],
                            ),
                          ),
                    children: [
                      for (final p
                          in _rank
                              .sort(insights.platforms)
                              .take(isPro ? insights.platforms.length : 1))
                        _StatsRow(
                          stats: p,
                          detail:
                              '${p.units} sold · '
                              '${_days(p.averageDaysToSell)} to sell · '
                              '${formatCents(p.averageFeesCents)} fees avg',
                        ),
                    ],
                  ),
                  _Section(
                    title: 'Best places to buy',
                    subtitle: 'Ranked by return on what you paid',
                    children: [
                      for (final s in _byRoi(
                        insights.sources,
                      ).take(isPro ? insights.sources.length : 1))
                        _StatsRow(
                          stats: s,
                          detail:
                              '${s.units} sold · '
                              '${_percent(s.roiPercent)} return',
                        ),
                    ],
                  ),
                  if (!isPro)
                    const Card(
                      child: ProLockTile(
                        title: 'See the full breakdown',
                        subtitle:
                            'Every platform and source, your best categories '
                            'and brands, slowest movers and date filters.',
                      ),
                    )
                  else ...[
                    _Section(
                      title: 'Best categories',
                      children: [
                        for (final c in insights.categories)
                          _StatsRow(
                            stats: c,
                            detail:
                                '${c.units} sold · '
                                '${_percent(c.marginPercent)} margin',
                          ),
                      ],
                    ),
                    _Section(
                      title: 'Best brands',
                      children: [
                        for (final b in insights.brands.take(10))
                          _StatsRow(
                            stats: b,
                            detail:
                                '${b.units} sold · '
                                '${_percent(b.marginPercent)} margin',
                          ),
                      ],
                    ),
                    _Section(
                      title: 'Slowest movers',
                      subtitle: 'Took the longest to sell',
                      children: [
                        for (final entry in insights.slowest)
                          ListTile(
                            title: Text(
                              entry.item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              entry.platform?.name ?? 'Unknown platform',
                              style: const TextStyle(color: GrimColors.ash),
                            ),
                            trailing: Text(_days(entry.daysToSell.toDouble())),
                            onTap: () =>
                                context.push('/sales/${entry.sale.id}'),
                          ),
                      ],
                    ),
                  ],
                ],
              ],
            ),
    );
  }

  static List<GroupStats> _byRoi(List<GroupStats> groups) => [...groups]
    ..sort((a, b) => (b.roiPercent ?? -1e9).compareTo(a.roiPercent ?? -1e9));

  static String _percent(double? value) =>
      value == null ? '—' : '${value.toStringAsFixed(0)}%';

  static String _days(double days) {
    final rounded = days.round();
    return '$rounded ${rounded == 1 ? 'day' : 'days'}';
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.children,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              style: const TextStyle(
                                color: GrimColors.ash,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    ?trailing,
                  ],
                ),
              ),
              const SizedBox(height: 4),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats, required this.detail});

  final GroupStats stats;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final profit = stats.profitCents;
    return ListTile(
      title: Text(stats.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        detail,
        style: const TextStyle(color: GrimColors.ash, fontSize: 12),
      ),
      trailing: Text(
        formatCents(profit),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: profit >= 0 ? GrimColors.ecto : GrimColors.blood,
        ),
      ),
    );
  }
}
