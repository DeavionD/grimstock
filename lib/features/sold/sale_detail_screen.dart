import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/money.dart';
import '../../data/item_repository.dart';
import '../../data/providers.dart';
import '../../data/sales_repository.dart';
import '../../theme/grim_theme.dart';
import '../inventory/item_form_screen.dart';

/// One sale: the money breakdown, where it was bought and sold, shipping,
/// and an undo for sales recorded by mistake.
class SaleDetailScreen extends ConsumerWidget {
  const SaleDetailScreen({super.key, required this.saleId});

  final int saleId;

  Future<void> _ship(
    BuildContext context,
    WidgetRef ref,
    SoldEntry entry,
  ) async {
    final controller = TextEditingController(
      text: entry.sale.trackingNumber ?? '',
    );
    final tracking = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as shipped'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Tracking number (optional)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Shipped'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (tracking == null) return;
    await ref
        .read(salesRepositoryProvider)
        .markShipped(entry.sale.id, trackingNumber: tracking);
  }

  Future<void> _undo(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Undo this sale?'),
        content: const Text(
          'The sale is deleted and the item goes back into your inventory.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: GrimColors.blood),
            child: const Text('Undo sale'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(salesRepositoryProvider).undoSale(saleId);
      if (context.mounted) context.pop();
    } on FreeLimitReached catch (e) {
      if (context.mounted) await showFreeLimitDialog(context, e.limit);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(saleProvider(saleId)).value;
    if (entry == null) {
      return Scaffold(appBar: AppBar(), body: const SizedBox.shrink());
    }
    final sale = entry.sale;
    final item = entry.item;
    final date = DateFormat.yMMMd();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'undo') _undo(context, ref);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'undo', child: Text('Undo sale')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(item.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            [
              'Sold ${date.format(sale.soldAt)}',
              if (sale.quantity > 1) '${sale.quantity} units',
              '${entry.daysToSell} days to sell',
            ].join(' · '),
            style: const TextStyle(color: GrimColors.ash),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _Row('Bought at', entry.purchaseSource?.name ?? 'Not set'),
                  _Row('Sold on', entry.platform?.name ?? 'Not set'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _Row('Sale price', formatCents(sale.salePriceCents)),
                  _Row(
                    'Platform fees',
                    '-${formatCents(sale.platformFeesCents)}',
                  ),
                  _Row(
                    'Shipping',
                    '-${formatCents(sale.outboundShippingCents)}',
                  ),
                  _Row('Packaging', '-${formatCents(sale.packagingCents)}'),
                  _Row('Cost', '-${formatCents(sale.totalCostCents)}'),
                  const Divider(height: 24),
                  _Row(
                    'Profit',
                    formatCents(sale.profitCents),
                    bold: true,
                    color: sale.profitCents >= 0
                        ? GrimColors.ecto
                        : GrimColors.blood,
                  ),
                  if (sale.marginPercent != null)
                    _Row(
                      'Margin',
                      '${sale.marginPercent!.toStringAsFixed(1)}%',
                    ),
                  if (sale.roiPercent != null)
                    _Row(
                      'Return on cost',
                      '${sale.roiPercent!.toStringAsFixed(1)}%',
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Row(
                    'Shipped',
                    sale.shippedAt == null
                        ? 'Not yet'
                        : date.format(sale.shippedAt!),
                  ),
                  if (sale.trackingNumber != null)
                    _Row('Tracking', sale.trackingNumber!),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _ship(context, ref, entry),
                      icon: const Icon(Icons.local_shipping_outlined),
                      label: Text(
                        sale.shippedAt == null
                            ? 'Mark as shipped'
                            : 'Edit tracking',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.bold = false, this.color});

  final String label;
  final String value;
  final bool bold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final weight = bold ? FontWeight.w700 : FontWeight.w500;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: GrimColors.ash)),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontWeight: weight, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
