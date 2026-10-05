import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/money.dart';
import '../../data/database.dart';
import '../../data/item_repository.dart';
import '../../data/providers.dart';
import '../../theme/grim_theme.dart';
import '../../widgets/empty_state.dart';
import 'item_status_ui.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  String _query = '';
  ItemStatus? _status;
  ItemSort _sort = ItemSort.newest;
  late Stream<List<ItemListEntry>> _items;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _items = ref
        .read(itemRepositoryProvider)
        .watchItems(query: _query, status: _status, sort: _sort);
  }

  void _update(VoidCallback change) => setState(() {
    change();
    _reload();
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          PopupMenuButton<ItemSort>(
            tooltip: 'Sort',
            icon: const Icon(Icons.sort),
            initialValue: _sort,
            onSelected: (sort) => _update(() => _sort = sort),
            itemBuilder: (context) => const [
              PopupMenuItem(value: ItemSort.newest, child: Text('Newest')),
              PopupMenuItem(value: ItemSort.oldest, child: Text('Oldest')),
              PopupMenuItem(
                value: ItemSort.costHighToLow,
                child: Text('Cost: high to low'),
              ),
              PopupMenuItem(
                value: ItemSort.nameAToZ,
                child: Text('Name: A to Z'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/inventory/new'),
        icon: const Icon(Icons.add),
        label: const Text('Add item'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search name, brand, size or SKU',
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
                _filterChip(null, 'All'),
                for (final status in ItemStatus.values)
                  _filterChip(status, status.label),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ItemListEntry>>(
              stream: _items,
              builder: (context, snapshot) {
                final entries = snapshot.data;
                if (entries == null) return const SizedBox.shrink();
                if (entries.isEmpty) {
                  final filtering = _query.isNotEmpty || _status != null;
                  return EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: filtering ? 'No matches' : 'No stock yet',
                    message: filtering
                        ? 'Try a different search or filter.'
                        : 'Tap "Add item" to log something you bought '
                              'to resell.',
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _ItemTile(entry: entries[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(ItemStatus? status, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: _status == status,
        onSelected: (_) => _update(() => _status = status),
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({required this.entry});

  final ItemListEntry entry;

  @override
  Widget build(BuildContext context) {
    final item = entry.item;
    final details = [
      entry.categoryName,
      item.sizeVariant,
      if (item.quantity > 1) 'Qty ${item.quantity}',
    ].whereType<String>().join(' · ');
    final days = item.daysInStock(DateTime.now());

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/inventory/${item.id}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (details.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        details,
                        style: const TextStyle(color: GrimColors.ash),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        StatusChip(item.status),
                        if (item.isActive) ...[
                          Text(
                            '$days ${days == 1 ? 'day' : 'days'}',
                            style: TextStyle(
                              color: days >= 60
                                  ? GrimColors.blood
                                  : GrimColors.ash,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatCents(item.unitCostCents),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'cost',
                    style: TextStyle(color: GrimColors.ash, fontSize: 12),
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
