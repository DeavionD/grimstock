import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/money.dart';
import '../../data/providers.dart';
import '../../data/sales_tax.dart';
import '../../theme/grim_theme.dart';

/// Works out sales tax on [priceCents] for a state, remembering the state.
/// Returns the tax in cents, or null if cancelled.
Future<int?> showSalesTaxDialog(
  BuildContext context,
  WidgetRef ref, {
  required int priceCents,
}) async {
  final db = ref.read(databaseProvider);
  final saved = stateSalesTax(await db.getSetting(homeStateSettingKey));
  if (!context.mounted) return null;
  final result = await showDialog<(StateSalesTax, int)>(
    context: context,
    builder: (context) =>
        _SalesTaxDialog(priceCents: priceCents, initial: saved),
  );
  if (result == null) return null;
  final (state, basisPoints) = result;
  await db.setSetting(homeStateSettingKey, state.code);
  return StateSalesTax.taxOn(priceCents, basisPoints);
}

class _SalesTaxDialog extends StatefulWidget {
  const _SalesTaxDialog({required this.priceCents, this.initial});

  final int priceCents;
  final StateSalesTax? initial;

  @override
  State<_SalesTaxDialog> createState() => _SalesTaxDialogState();
}

class _SalesTaxDialogState extends State<_SalesTaxDialog> {
  late StateSalesTax? _state = widget.initial;
  late final _rate = TextEditingController(
    text: widget.initial == null
        ? ''
        : _percentText(widget.initial!.averageBasisPoints),
  );

  @override
  void dispose() {
    _rate.dispose();
    super.dispose();
  }

  int? get _basisPoints => parseBasisPoints(_rate.text);

  @override
  Widget build(BuildContext context) {
    final bp = _basisPoints;
    final tax = bp == null ? null : StateSalesTax.taxOn(widget.priceCents, bp);
    return AlertDialog(
      title: const Text('Sales tax'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<StateSalesTax>(
            initialValue: _state,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'State you bought in'),
            items: [
              for (final s in stateSalesTaxes)
                DropdownMenuItem(value: s, child: Text(s.name)),
            ],
            onChanged: (s) => setState(() {
              _state = s;
              _rate.text = _percentText(s!.averageBasisPoints);
            }),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _rate,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Tax rate',
              suffixText: '%',
              helperText: _state == null
                  ? null
                  : 'State ${formatBasisPoints(_state!.stateBasisPoints)}, '
                        'average with local tax '
                        '${formatBasisPoints(_state!.averageBasisPoints)}. '
                        'Use your receipt\'s rate if it differs.',
              helperMaxLines: 3,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Text(
            tax == null
                ? 'Pick a state to work out the tax.'
                : '${formatCents(tax)} on ${formatCents(widget.priceCents)}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: GrimColors.bone,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _state == null || bp == null
              ? null
              : () => Navigator.of(context).pop((_state!, bp)),
          child: const Text('Use this'),
        ),
      ],
    );
  }
}

String _percentText(int basisPoints) =>
    formatBasisPoints(basisPoints).replaceAll('%', '');
