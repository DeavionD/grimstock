import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/money.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../../data/receipt_repository.dart';
import '../../theme/grim_theme.dart';
import '../../widgets/empty_state.dart';

/// Every scanned receipt, newest first, with this year's total.
class ReceiptsScreen extends ConsumerWidget {
  const ReceiptsScreen({super.key});

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.of(context).pop('camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from photos'),
              onTap: () => Navigator.of(context).pop('library'),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Enter it by hand'),
              onTap: () => Navigator.of(context).pop('manual'),
            ),
          ],
        ),
      ),
    );
    if (choice == null || !context.mounted) return;
    String? photo;
    if (choice != 'manual') {
      photo = await ref
          .read(photoStoreProvider)
          .pick(fromCamera: choice == 'camera', maxSize: 2400, quality: 85);
      if (photo == null || !context.mounted) return;
    }
    await context.push('/receipts/new', extra: photo);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receipts = ref.watch(receiptsProvider).value;
    final year = DateTime.now().year;
    final thisYear = (receipts ?? const <Receipt>[]).where(
      (r) => r.purchasedAt.year == year,
    );
    final total = thisYear.fold(0, (sum, r) => sum + r.totalCents);
    final tax = thisYear.fold(0, (sum, r) => sum + r.taxCents);

    return Scaffold(
      appBar: AppBar(title: const Text('Receipts')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context, ref),
        icon: const Icon(Icons.document_scanner_outlined),
        label: const Text('Scan receipt'),
      ),
      body: receipts == null
          ? const SizedBox.shrink()
          : receipts.isEmpty
          ? const EmptyState(
              icon: Icons.document_scanner_outlined,
              title: 'No receipts yet',
              message:
                  'Snap every purchase receipt. Grimstock keeps the photo, '
                  'reads the store, items, tax and total, and exports it all '
                  'for your taxes.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                Text(
                  '$year: ${formatCents(total)} '
                  '(${formatCents(tax)} tax) on ${thisYear.length} '
                  '${thisYear.length == 1 ? 'receipt' : 'receipts'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                for (final receipt in receipts)
                  Card(
                    child: ListTile(
                      leading: _Thumbnail(path: receipt.photoPath),
                      title: Text(
                        receipt.store.isEmpty ? 'Receipt' : receipt.store,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${DateFormat.yMMMd().format(receipt.purchasedAt)}'
                        ' · ${receipt.receiptPurpose.label}',
                        style: const TextStyle(color: GrimColors.ash),
                      ),
                      trailing: Text(
                        formatCents(receipt.totalCents),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      onTap: () => context.push('/receipts/${receipt.id}'),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    const icon = Icon(Icons.receipt_long_outlined, color: GrimColors.hex);
    if (path == null) return icon;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.file(
        File(path!),
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        cacheWidth: 120,
        errorBuilder: (_, _, _) => icon,
      ),
    );
  }
}
