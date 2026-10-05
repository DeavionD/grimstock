import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/money.dart';
import '../../data/database.dart';
import '../../data/item_repository.dart';
import '../../data/platform_presets.dart';
import '../../data/providers.dart';
import '../../theme/grim_theme.dart';
import '../../widgets/money_field.dart';
import '../../data/sales_repository.dart';
import 'item_form_screen.dart';
import 'item_status_ui.dart';
import 'listing_sheet.dart';
import 'photo_strip.dart';

class ItemDetailScreen extends ConsumerWidget {
  const ItemDetailScreen({super.key, required this.itemId});

  final int itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(itemDetailsProvider(itemId));
    return details.when(
      loading: () => const Scaffold(body: SizedBox.shrink()),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Could not load this item: $error')),
      ),
      data: (details) => details == null
          ? Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('This item was deleted.')),
            )
          : _ItemDetailView(details: details),
    );
  }
}

enum _MenuAction { duplicate, delete }

class _ItemDetailView extends ConsumerWidget {
  const _ItemDetailView({required this.details});

  final ItemDetails details;

  Future<void> _onMenu(
    BuildContext context,
    WidgetRef ref,
    _MenuAction action,
  ) async {
    final repo = ref.read(itemRepositoryProvider);
    final item = details.item;
    switch (action) {
      case _MenuAction.duplicate:
        try {
          final id = await repo.duplicateItem(item.id);
          if (context.mounted) context.pushReplacement('/inventory/$id');
        } on FreeLimitReached catch (e) {
          if (context.mounted) await showFreeLimitDialog(context, e.limit);
        }
      case _MenuAction.delete:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete this item?'),
            content: Text('"${item.name}" will be removed for good.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: GrimColors.blood),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (confirmed != true) return;
        try {
          final photos = await repo.deleteItem(item.id);
          await ref.read(photoStoreProvider).delete(photos);
          if (context.mounted) context.pop();
        } on ItemHasSales {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Sold items stay in your Sold archive and can\'t be deleted.',
                ),
              ),
            );
          }
        }
    }
  }

  Future<void> _changeStatus(
    BuildContext context,
    WidgetRef ref,
    ItemStatus status,
  ) async {
    try {
      await ref
          .read(itemRepositoryProvider)
          .updateStatus(details.item.id, status);
    } on FreeLimitReached catch (e) {
      if (context.mounted) await showFreeLimitDialog(context, e.limit);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = details.item;
    final text = Theme.of(context).textTheme;
    final subtitle = [
      details.category?.name,
      item.brand,
      item.sizeVariant,
    ].whereType<String>().join(' · ');

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('/inventory/${item.id}/edit'),
          ),
          PopupMenuButton<_MenuAction>(
            onSelected: (action) => _onMenu(context, ref, action),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _MenuAction.duplicate,
                child: Text('Duplicate'),
              ),
              PopupMenuItem(value: _MenuAction.delete, child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          Text(item.name, style: text.headlineSmall),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: GrimColors.ash)),
          ],
          const SizedBox(height: 16),
          PhotoStrip(itemId: item.id),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<ItemStatus>(
              showSelectedIcon: false,
              segments: [
                for (final s in const [
                  ItemStatus.purchased,
                  ItemStatus.inStock,
                  ItemStatus.listed,
                  ItemStatus.returned,
                ])
                  ButtonSegment(value: s, label: Text(s.label)),
              ],
              selected: {if (item.isActive) item.status},
              emptySelectionAllowed: true,
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  _changeStatus(context, ref, selection.first);
                }
              },
            ),
          ),
          if (!item.isActive) ...[
            const SizedBox(height: 8),
            StatusChip(item.status),
          ],
          if (item.isActive) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => context.push('/inventory/${item.id}/sell'),
              icon: const Icon(Icons.sell_outlined),
              label: Text(
                item.quantity > 1 ? 'Mark some or all as sold' : 'Mark as sold',
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => showListingSheet(context, details),
              icon: const Icon(Icons.edit_note),
              label: const Text('Write listing'),
            ),
          ],
          _ItemSales(itemId: item.id),
          const SizedBox(height: 16),
          _ProfitEstimator(item: item),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Cost per item',
            rows: [
              ('Price paid', formatCents(item.purchasePriceCents)),
              if (item.purchaseTaxCents > 0)
                ('Tax', formatCents(item.purchaseTaxCents)),
              if (item.inboundShippingCents > 0)
                ('Shipping to you', formatCents(item.inboundShippingCents)),
              if (item.otherCostsCents > 0)
                ('Other costs', formatCents(item.otherCostsCents)),
              ('Total cost', formatCents(item.unitCostCents)),
              if (item.quantity > 1) ...[
                ('Quantity', '${item.quantity}'),
                (
                  'Total for all',
                  formatCents(item.unitCostCents * item.quantity),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Details',
            rows: [
              if (item.condition != null) ('Condition', item.condition!),
              for (final (field, value) in details.fields)
                if (value != null) (field.label, value),
              if (item.sku != null) ('SKU / barcode', item.sku!),
              if (details.purchaseSource != null)
                ('Bought from', details.purchaseSource!.name),
              if (item.purchaseDate != null)
                ('Purchased', DateFormat.yMMMd().format(item.purchaseDate!)),
              if (item.isActive)
                ('Days in stock', '${item.daysInStock(DateTime.now())}'),
              if (item.storageLocation != null)
                ('Stored at', item.storageLocation!),
            ],
          ),
          if (item.notes != null) ...[
            const SizedBox(height: 16),
            _InfoCard(title: 'Notes', body: item.notes),
          ],
        ],
      ),
    );
  }
}

/// "What would I make?" for this item: pick a platform and a price and see
/// the profit after that platform's fees.
class _ProfitEstimator extends ConsumerStatefulWidget {
  const _ProfitEstimator({required this.item});

  final Item item;

  @override
  ConsumerState<_ProfitEstimator> createState() => _ProfitEstimatorState();
}

class _ProfitEstimatorState extends ConsumerState<_ProfitEstimator> {
  final _price = TextEditingController();
  final _shipping = TextEditingController();
  int? _platformId;

  @override
  void dispose() {
    _price.dispose();
    _shipping.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final platforms = ref.watch(platformsProvider).value ?? const [];
    final platform = platforms
        .where((p) => p.id == _platformId)
        .followedBy(platforms)
        .firstOrNull;
    final salePrice = parseCents(_price.text) ?? 0;
    final item = widget.item;
    final result = calculateProfit(
      ProfitInput(
        purchasePrice: item.purchasePriceCents,
        purchaseTax: item.purchaseTaxCents,
        inboundShipping: item.inboundShippingCents,
        otherCosts: item.otherCostsCents,
        salePrice: salePrice,
        fees: platform?.feeRule ?? const FeeRule(),
        outboundShipping: parseCents(_shipping.text) ?? 0,
      ),
    );
    final profitColor = result.netProfit >= 0
        ? GrimColors.ecto
        : GrimColors.blood;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What would I make?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: platform?.id,
              decoration: const InputDecoration(labelText: 'Sell on'),
              isExpanded: true,
              items: [
                for (final p in platforms)
                  DropdownMenuItem(
                    value: p.id,
                    child: Text(
                      '${p.name}  (${p.feeSummary})',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (id) => setState(() => _platformId = id),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: MoneyField(
                    controller: _price,
                    label: 'Sale price',
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MoneyField(
                    controller: _shipping,
                    label: 'Shipping you pay',
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            if (salePrice > 0) ...[
              const SizedBox(height: 16),
              _line('Platform fees', '-${formatCents(result.platformFees)}'),
              _line('Your cost', '-${formatCents(result.totalCost)}'),
              const Divider(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Profit',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    formatCents(result.netProfit),
                    style: TextStyle(
                      color: profitColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                [
                  if (result.marginPercent != null)
                    '${result.marginPercent!.toStringAsFixed(1)}% margin',
                  if (result.roiPercent != null)
                    '${result.roiPercent!.toStringAsFixed(1)}% ROI',
                ].join(' · '),
                textAlign: TextAlign.end,
                style: const TextStyle(color: GrimColors.ash),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _line(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: GrimColors.ash)),
        ),
        Text(value),
      ],
    ),
  );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, this.rows = const [], this.body});

  final String title;
  final List<(String, String)> rows;
  final String? body;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty && body == null) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (body != null) Text(body!),
            for (final (label, value) in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: const TextStyle(color: GrimColors.ash),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(child: Text(value, textAlign: TextAlign.end)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// This item's past sales, with profit. Tapping one opens it in the Sold
/// archive.
class _ItemSales extends ConsumerWidget {
  const _ItemSales({required this.itemId});

  final int itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sales = ref.watch(itemSalesProvider(itemId)).value ?? const [];
    if (sales.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                'Sales',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (final sale in sales)
              ListTile(
                title: Text(
                  '${sale.quantity > 1 ? '${sale.quantity} sold' : 'Sold'} '
                  'for ${formatCents(sale.salePriceCents)}',
                ),
                subtitle: Text(
                  DateFormat.yMMMd().format(sale.soldAt),
                  style: const TextStyle(color: GrimColors.ash),
                ),
                trailing: Text(
                  formatCents(sale.profitCents),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: sale.profitCents >= 0
                        ? GrimColors.ecto
                        : GrimColors.blood,
                  ),
                ),
                onTap: () => context.push('/sales/${sale.id}'),
              ),
          ],
        ),
      ),
    );
  }
}
