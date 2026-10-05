import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/money.dart';
import '../../data/export.dart';
import '../../data/providers.dart';
import '../../theme/grim_theme.dart';

/// Date ranges offered for export, built around tax years.
enum ExportRange {
  thisYear('This year'),
  lastYear('Last year'),
  allTime('All time');

  const ExportRange(this.label);

  final String label;

  (DateTime?, DateTime?) bounds(DateTime now) => switch (this) {
    ExportRange.thisYear => (DateTime(now.year), DateTime(now.year + 1)),
    ExportRange.lastYear => (DateTime(now.year - 1), DateTime(now.year)),
    ExportRange.allTime => (null, null),
  };

  String fileTag(DateTime now) => switch (this) {
    ExportRange.thisYear => '${now.year}',
    ExportRange.lastYear => '${now.year - 1}',
    ExportRange.allTime => 'all-time',
  };

  String periodLabel(DateTime now) => switch (this) {
    ExportRange.allTime => 'All time',
    _ => fileTag(now),
  };
}

/// Exports inventory, sales, expenses and a profit and loss summary as CSV
/// files to share, save or email.
class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  ExportRange _range = ExportRange.thisYear;
  bool _busy = false;
  late Future<ProfitAndLoss> _summary;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  void _loadSummary() {
    final (from, to) = _range.bounds(DateTime.now());
    _summary = ref.read(exporterProvider).profitAndLoss(from: from, to: to);
  }

  Future<void> _share(Set<String> which) async {
    setState(() => _busy = true);
    try {
      final exporter = ref.read(exporterProvider);
      final now = DateTime.now();
      final (from, to) = _range.bounds(now);
      final tag = _range.fileTag(now);
      final dir = await getTemporaryDirectory();
      final files = <XFile>[];

      Future<void> write(String name, Future<String> csv) async {
        final file = File(p.join(dir.path, 'grimstock-$name-$tag.csv'));
        await file.writeAsString(await csv);
        files.add(XFile(file.path, mimeType: 'text/csv'));
      }

      if (which.contains('pnl')) {
        await write(
          'profit-and-loss',
          exporter.profitAndLossCsv(
            from: from,
            to: to,
            periodLabel: _range.periodLabel(now),
          ),
        );
      }
      if (which.contains('sales')) {
        await write('sales', exporter.salesCsv(from: from, to: to));
      }
      if (which.contains('expenses')) {
        await write('expenses', exporter.expensesCsv(from: from, to: to));
      }
      if (which.contains('inventory')) {
        await write('inventory', exporter.inventoryCsv());
      }
      await SharePlus.instance.share(
        ShareParams(files: files, subject: 'Grimstock export ($tag)'),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            children: [
              for (final range in ExportRange.values)
                ChoiceChip(
                  label: Text(range.label),
                  selected: _range == range,
                  onSelected: (_) => setState(() {
                    _range = range;
                    _loadSummary();
                  }),
                ),
            ],
          ),
          const SizedBox(height: 12),
          FutureBuilder<ProfitAndLoss>(
            future: _summary,
            builder: (context, snapshot) {
              final pnl = snapshot.data;
              if (pnl == null) return const SizedBox(height: 120);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _Line('Sales revenue', pnl.revenueCents),
                      _Line('Cost of goods sold', -pnl.costOfGoodsCents),
                      _Line(
                        'Fees, shipping and packaging',
                        -(pnl.platformFeesCents +
                            pnl.shippingCents +
                            pnl.packagingCents),
                      ),
                      _Line('Expenses', -pnl.expensesCents),
                      const Divider(height: 20),
                      _Line('Net profit', pnl.netProfitCents, bold: true),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _busy
                ? null
                : () => _share({'pnl', 'sales', 'expenses', 'inventory'}),
            icon: const Icon(Icons.ios_share),
            label: const Text('Export everything'),
          ),
          const SizedBox(height: 8),
          for (final (key, title, subtitle) in const [
            ('pnl', 'Profit and loss', 'Totals for your taxes'),
            ('sales', 'Sales', 'Every sale with fees, cost and profit'),
            ('expenses', 'Expenses', 'Supplies, subscriptions and mileage'),
            ('inventory', 'Inventory', 'Everything you own right now'),
          ])
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(title),
              subtitle: Text(
                subtitle,
                style: const TextStyle(color: GrimColors.ash),
              ),
              trailing: const Icon(Icons.ios_share),
              enabled: !_busy,
              onTap: () => _share({key}),
            ),
          const SizedBox(height: 8),
          const Text(
            'CSV files open in Excel, Google Sheets and Numbers. '
            'This summary is not tax advice.',
            style: TextStyle(color: GrimColors.ash, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.label, this.cents, {this.bold = false});

  final String label;
  final int cents;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final weight = bold ? FontWeight.w700 : FontWeight.w500;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: bold ? GrimColors.bone : GrimColors.ash,
                fontWeight: weight,
              ),
            ),
          ),
          Text(
            formatCents(cents),
            style: TextStyle(
              fontWeight: weight,
              color: bold
                  ? (cents >= 0 ? GrimColors.ecto : GrimColors.blood)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
