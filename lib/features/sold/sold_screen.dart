import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/money.dart';
import '../../data/providers.dart';
import '../../data/sales_repository.dart';
import '../../theme/grim_theme.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_thumb.dart';

/// The archive of every sale, with where each item was bought and sold.
class SoldScreen extends ConsumerStatefulWidget {
  const SoldScreen({super.key});

  @override
  ConsumerState<SoldScreen> createState() => _SoldScreenState();
}

class _SoldScreenState extends ConsumerState<SoldScreen> {
  String _query = '';
  int? _platformId;
  late Stream<List<SoldEntry>> _sold;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _sold = ref
        .read(salesRepositoryProvider)
        .watchSold(query: _query, platformId: _platformId);
  }

  void _update(VoidCallback change) => setState(() {
    change();
    _reload();
  });

  @override
  Widget build(BuildContext context) {
    final platforms = ref.watch(platformsProvider).value ?? const [];
    final covers = ref.watch(coverPhotosProvider).value ?? const {};

    return Scaffold(
      appBar: AppBar(title: const Text('Sold')),
      body: StreamBuilder<List<SoldEntry>>(
        stream: _sold,
        builder: (context, snapshot) {
          final entries = snapshot.data;
          if (entries == null) return const SizedBox.shrink();
          final filtering = _query.isNotEmpty || _platformId != null;
          if (entries.isEmpty && !filtering) {
            return const EmptyState(
              icon: Icons.archive_outlined,
              title: 'Nothing sold yet',
              message:
                  'Every sale is archived here for good, with where you '
                  'bought it, where it sold, and what you made.',
            );
          }

          var revenue = 0, profit = 0;
          for (final entry in entries) {
            revenue += entry.sale.salePriceCents;
            profit += entry.sale.profitCents;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search name, brand or SKU',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) => _update(() => _query = value),
                ),
              ),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _platformChip(null, 'All'),
                    for (final p in platforms) _platformChip(p.id, p.name),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    _Total(label: 'Sales', value: '${entries.length}'),
                    _Total(label: 'Revenue', value: formatCents(revenue)),
                    _Total(
                      label: 'Profit',
                      value: formatCents(profit),
                      color: profit >= 0 ? GrimColors.ecto : GrimColors.blood,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: entries.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_off,
                        title: 'No matches',
                        message: 'Try a different search or platform.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: entries.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) => _SoldTile(
                          entry: entries[index],
                          coverPath: covers[entries[index].item.id],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _platformChip(int? id, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: _platformId == id,
        onSelected: (_) => _update(() => _platformId = id),
      ),
    );
  }
}

class _Total extends StatelessWidget {
  const _Total({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: GrimColors.ash, fontSize: 12),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: color ?? GrimColors.bone,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoldTile extends StatelessWidget {
  const _SoldTile({required this.entry, this.coverPath});

  final SoldEntry entry;
  final String? coverPath;

  @override
  Widget build(BuildContext context) {
    final sale = entry.sale;
    final route = [
      entry.purchaseSource?.name ?? 'Unknown source',
      entry.platform?.name ?? 'Unknown platform',
    ].join(' → ');
    final when = [
      DateFormat.yMMMd().format(sale.soldAt),
      if (sale.quantity > 1) '${sale.quantity} units',
      if (sale.shippedAt != null) 'Shipped',
    ].join(' · ');

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/sales/${sale.id}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              ItemThumb(path: coverPath),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      route,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: GrimColors.hex),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      when,
                      style: const TextStyle(
                        color: GrimColors.ash,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatCents(sale.profitCents),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: sale.profitCents >= 0
                          ? GrimColors.ecto
                          : GrimColors.blood,
                    ),
                  ),
                  Text(
                    'of ${formatCents(sale.salePriceCents)}',
                    style: const TextStyle(color: GrimColors.ash, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
