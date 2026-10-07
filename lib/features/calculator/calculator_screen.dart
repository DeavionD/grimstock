import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/money.dart';
import '../../data/database.dart';
import '../../data/deal_check.dart';
import '../../data/platform_presets.dart';
import '../../data/providers.dart';
import '../../data/upc_lookup.dart';
import '../../theme/grim_theme.dart';
import '../../widgets/money_field.dart';
import '../inventory/item_form_screen.dart';
import '../inventory/scanner_screen.dart';
import '../pro/paywall_screen.dart';

enum _Mode { compare, target }

enum _TargetKind { dollars, roi }

/// "Should I buy this?" Enter the cost and an expected sale price to see
/// the profit on every platform, best first, and (Pro) a green, yellow or
/// red deal check. Or enter the profit you want and see what to list for.
class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  final _buy = TextEditingController();
  final _tax = TextEditingController();
  final _inbound = TextEditingController();
  final _sell = TextEditingController();
  final _shipping = TextEditingController();
  final _packaging = TextEditingController();
  final _target = TextEditingController();
  var _mode = _Mode.compare;
  var _targetKind = _TargetKind.dollars;
  String? _barcode;
  ProductInfo? _product;
  bool _looking = false;

  List<TextEditingController> get _fields => [
    _buy,
    _tax,
    _inbound,
    _sell,
    _shipping,
    _packaging,
    _target,
  ];

  @override
  void dispose() {
    for (final c in _fields) {
      c.dispose();
    }
    super.dispose();
  }

  void _clear() => setState(() {
    for (final c in _fields) {
      c.clear();
    }
    _barcode = null;
    _product = null;
  });

  int get _cost => centsFrom(_buy) + centsFrom(_tax) + centsFrom(_inbound);

  PriceHistory? _history() {
    if (_barcode == null && _product == null) return null;
    return priceHistoryFor(
      ref.read(allSoldProvider).value ?? const [],
      barcode: _barcode,
      name: _product?.title,
    );
  }

  Future<void> _scan() async {
    if (!ref.read(isProProvider)) {
      showPaywall(context);
      return;
    }
    final code = await Navigator.of(context)
        .push<String>(MaterialPageRoute(builder: (_) => const ScannerScreen()));
    if (code == null || !mounted) return;
    setState(() {
      _barcode = code;
      _product = null;
      _looking = true;
    });
    final info = await ref.read(upcLookupProvider).lookup(code);
    if (!mounted) return;
    setState(() {
      _looking = false;
      _product = info;
      final history = _history();
      if (history != null && centsFrom(_sell) == 0) {
        _sell.text = centsText(history.averageUnitPriceCents);
      }
    });
  }

  List<(Platform, ProfitResult)> _ranked(List<Platform> platforms) {
    final results = [
      for (final platform in platforms)
        (
          platform,
          calculateProfit(
            ProfitInput(
              purchasePrice: centsFrom(_buy),
              purchaseTax: centsFrom(_tax),
              inboundShipping: centsFrom(_inbound),
              salePrice: centsFrom(_sell),
              fees: platform.feeRule,
              outboundShipping: centsFrom(_shipping),
              packaging: centsFrom(_packaging),
            ),
          ),
        ),
    ];
    results.sort((a, b) => b.$2.netProfit.compareTo(a.$2.netProfit));
    return results;
  }

  /// The profit the user asked for, in cents. Null until it's entered.
  int? get _targetProfit {
    if (_target.text.trim().isEmpty) return null;
    if (_targetKind == _TargetKind.dollars) return centsFrom(_target);
    final bp = parseBasisPoints(_target.text);
    return bp == null ? null : (_cost * bp / 10000).round();
  }

  List<(Platform, int?)> _listPrices(List<Platform> platforms, int target) {
    final prices = [
      for (final platform in platforms)
        (
          platform,
          listPriceFor(
            platform.feeRule,
            costCents: _cost,
            targetProfitCents: target,
            outboundShippingCents: centsFrom(_shipping),
            packagingCents: centsFrom(_packaging),
          ),
        ),
    ];
    prices.sort((a, b) => (a.$2 ?? 1 << 40).compareTo(b.$2 ?? 1 << 40));
    return prices;
  }

  List<Widget> _targetResults(
    BuildContext context,
    List<Platform> platforms,
    int? target,
  ) {
    if (target == null) {
      return const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'Enter what you paid and the profit or ROI you want, and see '
            'what to list it for on every platform.',
            textAlign: TextAlign.center,
            style: TextStyle(color: GrimColors.ash),
          ),
        ),
      ];
    }
    return [
      Text('List it for', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      for (final (platform, price) in _listPrices(platforms, target))
        Card(
          child: ListTile(
            title: Text(platform.name),
            subtitle: Text(
              price == null
                  ? 'Out of reach'
                  : 'Fees ${formatCents(platform.feeRule.feesFor(price))}',
              style: const TextStyle(color: GrimColors.ash, fontSize: 12),
            ),
            trailing: Text(
              price == null ? '–' : formatCents(price),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: GrimColors.ecto,
              ),
            ),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final platforms = ref.watch(platformsProvider).value ?? const [];
    final pro = ref.watch(isProProvider);
    ref.watch(allSoldProvider);
    final history = _history();
    final hasPrices = centsFrom(_sell) > 0;
    final ranked = hasPrices
        ? _ranked(platforms)
        : const <(Platform, ProfitResult)>[];
    final target = _targetProfit;
    void changed(String _) => setState(() {});

    return Scaffold(
      appBar: AppBar(
        title: const Text('Should I buy this?'),
        actions: [
          IconButton(
            tooltip: 'Scan a barcode',
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scan,
          ),
          IconButton(
            tooltip: 'Clear',
            icon: const Icon(Icons.refresh),
            onPressed: _clear,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_barcode != null) ...[
            _ScannedProduct(
              barcode: _barcode!,
              product: _product,
              looking: _looking,
              history: history,
            ),
            const SizedBox(height: 12),
          ],
          SegmentedButton<_Mode>(
            segments: const [
              ButtonSegment(value: _Mode.compare, label: Text('Profit')),
              ButtonSegment(
                value: _Mode.target,
                label: Text('What to list for'),
              ),
            ],
            selected: {_mode},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() => _mode = s.first),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: MoneyField(
                  controller: _buy,
                  label: 'Buy price',
                  onChanged: changed,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _mode == _Mode.compare
                    ? MoneyField(
                        controller: _sell,
                        label: 'Expected sale price',
                        onChanged: changed,
                      )
                    : TextField(
                        key: const Key('target'),
                        controller: _target,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: _targetKind == _TargetKind.dollars
                              ? 'Profit I want'
                              : 'ROI I want',
                          prefixText: _targetKind == _TargetKind.dollars
                              ? r'$ '
                              : null,
                          suffixText: _targetKind == _TargetKind.roi
                              ? '%'
                              : null,
                        ),
                        onChanged: changed,
                      ),
              ),
            ],
          ),
          if (_mode == _Mode.target) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: SegmentedButton<_TargetKind>(
                segments: const [
                  ButtonSegment(value: _TargetKind.dollars, label: Text(r'$')),
                  ButtonSegment(value: _TargetKind.roi, label: Text('ROI %')),
                ],
                selected: {_targetKind},
                showSelectedIcon: false,
                onSelectionChanged: (s) =>
                    setState(() => _targetKind = s.first),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: MoneyField(
                  controller: _tax,
                  label: 'Tax',
                  onChanged: changed,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MoneyField(
                  controller: _inbound,
                  label: 'Shipping to you',
                  onChanged: changed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: MoneyField(
                  controller: _shipping,
                  label: 'Shipping to buyer',
                  onChanged: changed,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MoneyField(
                  controller: _packaging,
                  label: 'Packaging',
                  onChanged: changed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_mode == _Mode.target)
            ..._targetResults(context, platforms, target)
          else if (!hasPrices)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Enter an expected sale price to compare your profit '
                'after fees on every platform.',
                textAlign: TextAlign.center,
                style: TextStyle(color: GrimColors.ash),
              ),
            )
          else ...[
            if (_cost > 0 && ranked.isNotEmpty) ...[
              if (pro)
                _DealCheckCard(
                  check: checkDeal(
                    totalCostCents: _cost,
                    bestProfitCents: ranked.first.$2.netProfit,
                    history: history,
                  ),
                )
              else
                Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => showPaywall(context),
                    child: const ProLockTile(
                      title: 'Deal check',
                      subtitle:
                          'Green, yellow or red: is it worth buying at this '
                          'price?',
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
            Text(
              'Profit by platform',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final (index, (platform, result)) in ranked.indexed)
              _PlatformResult(
                platform: platform,
                result: result,
                best: index == 0 && result.netProfit > 0,
              ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => context.go(
                '/inventory/new',
                extra: ItemPrefill(
                  purchasePriceCents: centsFrom(_buy),
                  purchaseTaxCents: centsFrom(_tax),
                  inboundShippingCents: centsFrom(_inbound),
                  name: _product?.title,
                  brand: _product?.brand,
                  sku: _barcode,
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Bought it? Add to inventory'),
            ),
          ],
        ],
      ),
    );
  }
}

class _PlatformResult extends StatelessWidget {
  const _PlatformResult({
    required this.platform,
    required this.result,
    required this.best,
  });

  final Platform platform;
  final ProfitResult result;
  final bool best;

  @override
  Widget build(BuildContext context) {
    final profit = result.netProfit;
    final margin = result.marginPercent;
    return Card(
      shape: best
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: GrimColors.ecto),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        platform.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      if (best)
                        const Text(
                          'Best',
                          style: TextStyle(
                            color: GrimColors.ecto,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Fees ${formatCents(result.platformFees)}'
                    '${margin == null ? '' : ' · ${margin.toStringAsFixed(1)}% margin'}',
                    style: const TextStyle(color: GrimColors.ash, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              formatCents(profit),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: profit >= 0 ? GrimColors.ecto : GrimColors.blood,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannedProduct extends StatelessWidget {
  const _ScannedProduct({
    required this.barcode,
    required this.product,
    required this.looking,
    required this.history,
  });

  final String barcode;
  final ProductInfo? product;
  final bool looking;
  final PriceHistory? history;

  @override
  Widget build(BuildContext context) {
    final history = this.history;
    final lines = [
      if (product?.brand != null) product!.brand!,
      'Barcode $barcode',
      if (history != null)
        'You sold it ${history.sales == 1 ? 'once' : '${history.sales} times'}'
            ' for ${formatCents(history.averageUnitPriceCents)} on average',
    ];
    return Card(
      child: ListTile(
        leading: looking
            ? const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.qr_code_2),
        title: Text(
          looking
              ? 'Looking up barcode…'
              : product?.title ?? 'No product found for this barcode',
        ),
        subtitle: Text(
          lines.join('\n'),
          style: const TextStyle(color: GrimColors.ash),
        ),
      ),
    );
  }
}

class _DealCheckCard extends StatelessWidget {
  const _DealCheckCard({required this.check});

  final DealCheck check;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (check.verdict) {
      DealVerdict.good => (Icons.check_circle, GrimColors.ecto),
      DealVerdict.risky => (Icons.check_circle_outline, GrimColors.pyre),
      DealVerdict.pass => (Icons.cancel, GrimColors.blood),
    };
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    check.verdict.label,
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  for (final reason in check.reasons)
                    Text(reason, style: const TextStyle(color: GrimColors.ash)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
