import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/money.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../../theme/grim_theme.dart';
import '../../widgets/money_field.dart';

/// Edit a selling platform's name and fees.
class PlatformEditScreen extends ConsumerStatefulWidget {
  const PlatformEditScreen({super.key, required this.platformId});

  final int platformId;

  @override
  ConsumerState<PlatformEditScreen> createState() => _PlatformEditScreenState();
}

class _PlatformEditScreenState extends ConsumerState<PlatformEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _fee = TextEditingController();
  final _processing = TextEditingController();
  final _fixed = TextEditingController();
  final _minimum = TextEditingController();
  final _smallThreshold = TextEditingController();
  final _smallFlat = TextEditingController();
  final _note = TextEditingController();
  Platform? _platform;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    final platform = await (db.select(
      db.platforms,
    )..where((p) => p.id.equals(widget.platformId))).getSingle();
    if (!mounted) return;
    String percent(int bp) => bp == 0 ? '' : (bp / 100).toString();
    setState(() {
      _platform = platform;
      _name.text = platform.name;
      _fee.text = percent(platform.feeBasisPoints);
      _processing.text = percent(platform.processingBasisPoints);
      _fixed.text = centsText(platform.fixedFeeCents);
      _minimum.text = centsText(platform.minimumFeeCents);
      _smallThreshold.text = centsText(platform.smallSaleThresholdCents);
      _smallFlat.text = centsText(platform.smallSaleFlatFeeCents);
      _note.text = platform.note ?? '';
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final note = _note.text.trim();
    await ref
        .read(databaseProvider)
        .updatePlatform(
          _platform!.copyWith(
            name: _name.text.trim(),
            feeBasisPoints: parseBasisPoints(_fee.text) ?? 0,
            processingBasisPoints: parseBasisPoints(_processing.text) ?? 0,
            fixedFeeCents: centsFrom(_fixed),
            minimumFeeCents: centsFrom(_minimum),
            smallSaleThresholdCents: centsFrom(_smallThreshold),
            smallSaleFlatFeeCents: centsFrom(_smallFlat),
            note: Value(note.isEmpty ? null : note),
          ),
        );
    if (mounted) context.pop();
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _fee,
      _processing,
      _fixed,
      _minimum,
      _smallThreshold,
      _smallFlat,
      _note,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _validatePercent(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final bp = parseBasisPoints(text);
    return bp == null || bp > 10000 ? 'Enter a percent like 9.5' : null;
  }

  Widget _percentField(TextEditingController controller, String label) =>
      TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, suffixText: '%'),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: _validatePercent,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform fees'),
        actions: [
          TextButton(
            onPressed: _platform == null ? null : _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: _platform == null
          ? const SizedBox.shrink()
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (v) =>
                        (v?.trim().isEmpty ?? true) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _note,
                    decoration: const InputDecoration(
                      labelText: 'Note',
                      hintText: 'e.g. Seller Level 2',
                    ),
                  ),
                  const SizedBox(height: 24),
                  _percentField(_fee, 'Selling fee'),
                  const SizedBox(height: 12),
                  _percentField(_processing, 'Payment processing / cash-out'),
                  const SizedBox(height: 12),
                  MoneyField(controller: _fixed, label: 'Fixed fee per order'),
                  const SizedBox(height: 12),
                  MoneyField(controller: _minimum, label: 'Minimum total fee'),
                  const SizedBox(height: 24),
                  const Text(
                    'Small sales (optional)',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Some platforms charge a flat fee instead of the '
                    'percentage on cheap items. Poshmark, for example, '
                    r'charges $2.95 on sales under $15.',
                    style: TextStyle(color: GrimColors.ash),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: MoneyField(
                          controller: _smallThreshold,
                          label: 'Sales under',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MoneyField(
                          controller: _smallFlat,
                          label: 'Flat fee',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Fees change often and depend on your seller level. '
                    'Check the platform\'s fee page if a number looks off.',
                    style: TextStyle(color: GrimColors.ash),
                  ),
                ],
              ),
            ),
    );
  }
}
