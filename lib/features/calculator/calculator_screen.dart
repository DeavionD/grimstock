import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/money.dart';
import '../../data/database.dart';
import '../../data/platform_presets.dart';
import '../../data/providers.dart';
import '../../theme/grim_theme.dart';
import '../../widgets/money_field.dart';
import '../inventory/item_form_screen.dart';

/// "Should I buy this?" Enter the cost and an expected sale price to see
/// the profit on every platform, best first.
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

  @override
  void dispose() {
    for (final c in [_buy, _tax, _inbound, _sell, _shipping, _packaging]) {
      c.dispose();
    }
    super.dispose();
  }

  void _clear() => setState(() {
    for (final c in [_buy, _tax, _inbound, _sell, _shipping, _packaging]) {
      c.clear();
    }
  });

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

  @override
  Widget build(BuildContext context) {
    final platforms = ref.watch(platformsProvider).value ?? const [];
    final hasPrices = centsFrom(_sell) > 0;
    final ranked = hasPrices
        ? _ranked(platforms)
        : const <(Platform, ProfitResult)>[];
    void changed(String _) => setState(() {});

    return Scaffold(
      appBar: AppBar(
        title: const Text('Should I buy this?'),
        actions: [
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
                child: MoneyField(
                  controller: _sell,
                  label: 'Expected sale price',
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
          if (!hasPrices)
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
