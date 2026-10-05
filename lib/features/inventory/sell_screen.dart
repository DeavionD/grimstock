import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/money.dart';
import '../../data/database.dart';
import '../../data/item_repository.dart';
import '../../data/platform_presets.dart';
import '../../data/providers.dart';
import '../../data/sales_repository.dart';
import '../../theme/grim_theme.dart';
import '../../widgets/money_field.dart';

/// Records a sale for an item: where it sold, for how much, and what it
/// cost to sell. Fees fill in from the platform's preset and can be edited.
class SellScreen extends ConsumerStatefulWidget {
  const SellScreen({super.key, required this.itemId});

  final int itemId;

  @override
  ConsumerState<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends ConsumerState<SellScreen> {
  final _formKey = GlobalKey<FormState>();
  final _price = TextEditingController();
  final _fees = TextEditingController();
  final _shipping = TextEditingController();
  final _packaging = TextEditingController();
  final _tracking = TextEditingController();
  int _quantity = 1;
  int? _platformId;
  DateTime _soldAt = DateTime.now();

  /// True once the user types their own fee, so we stop overwriting it.
  bool _feesEdited = false;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_price, _fees, _shipping, _packaging, _tracking]) {
      c.dispose();
    }
    super.dispose();
  }

  Platform? _platform(List<Platform> platforms) =>
      platforms.where((p) => p.id == _platformId).firstOrNull ??
      platforms.firstOrNull;

  void _refreshFees(List<Platform> platforms) {
    if (_feesEdited) return;
    final fees = suggestedFees(
      _platform(platforms)?.feeRule,
      centsFrom(_price),
      _quantity,
    );
    _fees.text = centsText(fees);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _soldAt,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
    );
    if (picked != null) setState(() => _soldAt = picked);
  }

  Future<void> _save(Item item, Platform? platform) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(salesRepositoryProvider)
          .recordSale(
            SaleDraft(
              itemId: item.id,
              quantity: _quantity,
              platformId: platform?.id,
              soldAt: _soldAt,
              salePriceCents: centsFrom(_price),
              platformFeesCents: centsFrom(_fees),
              outboundShippingCents: centsFrom(_shipping),
              packagingCents: centsFrom(_packaging),
              trackingNumber: _tracking.text,
            ),
          );
      if (mounted) context.pop();
    } on NotEnoughQuantity catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Only ${e.available} left to sell.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(itemDetailsProvider(widget.itemId)).value;
    final platforms = ref.watch(platformsProvider).value ?? const [];
    if (details == null) return const Scaffold(body: SizedBox.shrink());
    final item = details.item;
    final platform = _platform(platforms);

    final sale = centsFrom(_price);
    final cost = item.unitCostCents * _quantity;
    final profit =
        sale -
        centsFrom(_fees) -
        centsFrom(_shipping) -
        centsFrom(_packaging) -
        cost;

    return Scaffold(
      appBar: AppBar(title: const Text('Mark as sold')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(item.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Cost ${formatCents(item.unitCostCents)} each',
              style: const TextStyle(color: GrimColors.ash),
            ),
            if (item.quantity > 1) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(child: Text('How many sold?')),
                  IconButton(
                    tooltip: 'One fewer',
                    onPressed: _quantity > 1
                        ? () => setState(() {
                            _quantity--;
                            _refreshFees(platforms);
                          })
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text(
                    '$_quantity of ${item.quantity}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    tooltip: 'One more',
                    onPressed: _quantity < item.quantity
                        ? () => setState(() {
                            _quantity++;
                            _refreshFees(platforms);
                          })
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: platform?.id,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Sold on'),
              items: [
                for (final p in platforms)
                  DropdownMenuItem(
                    value: p.id,
                    child: Text(p.name, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (id) => setState(() {
                _platformId = id;
                _feesEdited = false;
                _refreshFees(platforms);
              }),
            ),
            const SizedBox(height: 12),
            MoneyField(
              controller: _price,
              label: _quantity > 1 ? 'Total sale price' : 'Sale price',
              required: true,
              onChanged: (_) => setState(() => _refreshFees(platforms)),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _fees,
              decoration: InputDecoration(
                labelText: 'Platform fees',
                prefixText: r'$ ',
                helperText: _feesEdited
                    ? 'Edited by you'
                    : 'From ${platform?.name ?? 'platform'} preset '
                          '(${platform?.feeSummary ?? 'no fees'})',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => setState(() => _feesEdited = true),
              validator: (v) {
                final text = v?.trim() ?? '';
                if (text.isEmpty) return null;
                final cents = parseCents(text);
                return cents == null || cents < 0
                    ? 'Enter an amount like 12.50'
                    : null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: MoneyField(
                    controller: _shipping,
                    label: 'Shipping you paid',
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MoneyField(
                    controller: _packaging,
                    label: 'Packaging',
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _tracking,
              decoration: const InputDecoration(
                labelText: 'Tracking number (optional)',
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sold on'),
              subtitle: Text(
                DateFormat.yMMMd().format(_soldAt),
                style: const TextStyle(color: GrimColors.ash),
              ),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: _pickDate,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Your profit',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      sale == 0 ? '—' : formatCents(profit),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: profit >= 0 ? GrimColors.ecto : GrimColors.blood,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : () => _save(item, platform),
              child: const Text('Record sale'),
            ),
          ],
        ),
      ),
    );
  }
}
