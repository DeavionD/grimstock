import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/money.dart';
import '../../data/photo_store.dart';
import '../../data/providers.dart';
import '../../data/receipt_parser.dart';
import '../../data/receipt_repository.dart';
import '../../theme/grim_theme.dart';
import '../../widgets/money_field.dart';

/// Check and save a scanned receipt ([receiptId] null), or edit one. A new
/// receipt with a [photoPath] is read on the phone and the form filled in.
class ReceiptFormScreen extends ConsumerStatefulWidget {
  const ReceiptFormScreen({super.key, this.receiptId, this.photoPath});

  final int? receiptId;
  final String? photoPath;

  @override
  ConsumerState<ReceiptFormScreen> createState() => _ReceiptFormScreenState();
}

class _ReceiptFormScreenState extends ConsumerState<ReceiptFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _store = TextEditingController();
  final _subtotal = TextEditingController();
  final _tax = TextEditingController();
  final _total = TextEditingController();
  final _notes = TextEditingController();
  final _lines = <(TextEditingController, TextEditingController)>[];
  DateTime _date = DateTime.now();
  ReceiptPurpose _purpose = ReceiptPurpose.inventory;
  String? _photo;
  String? _scannedText;
  bool _reading = false;
  bool _unreadable = false;
  bool _saving = false;
  bool _saved = false;

  late final PhotoStore _photoStore;

  bool get _isEdit => widget.receiptId != null;

  @override
  void initState() {
    super.initState();
    _photoStore = ref.read(photoStoreProvider);
    _photo = widget.photoPath;
    if (_isEdit) {
      _load();
    } else if (_photo != null) {
      _read(_photo!);
    }
  }

  Future<void> _load() async {
    final details = await ref
        .read(receiptRepositoryProvider)
        .getReceipt(widget.receiptId!);
    if (!mounted || details == null) return;
    final r = details.receipt;
    setState(() {
      _store.text = r.store;
      _date = r.purchasedAt;
      _purpose = r.receiptPurpose;
      _subtotal.text = r.subtotalCents == null
          ? ''
          : centsText(r.subtotalCents!);
      _tax.text = centsText(r.taxCents);
      _total.text = centsText(r.totalCents);
      _notes.text = r.notes ?? '';
      _photo = r.photoPath;
      _scannedText = r.scannedText;
      for (final line in details.lines) {
        _addLine(line.description, line.amountCents);
      }
    });
  }

  Future<void> _read(String path) async {
    setState(() => _reading = true);
    final text = await ref.read(receiptReaderProvider).read(path);
    if (!mounted) return;
    final parsed = text == null ? null : parseReceipt(text);
    setState(() {
      _reading = false;
      _scannedText = text;
      _unreadable = parsed == null || parsed.totalCents == null;
      if (parsed == null) return;
      _store.text = parsed.store ?? '';
      if (parsed.date != null) _date = parsed.date!;
      if (parsed.subtotalCents != null) {
        _subtotal.text = centsText(parsed.subtotalCents!);
      }
      if (parsed.taxCents != null) _tax.text = centsText(parsed.taxCents!);
      if (parsed.totalCents != null) {
        _total.text = centsText(parsed.totalCents!);
      }
      for (final (description, amount) in parsed.lines) {
        _addLine(description, amount);
      }
    });
  }

  void _addLine([String description = '', int? amount]) {
    _lines.add((
      TextEditingController(text: description),
      TextEditingController(text: amount == null ? '' : centsText(amount)),
    ));
  }

  @override
  void dispose() {
    // A new receipt's photo that was never saved is thrown away.
    if (!_isEdit && !_saved && _photo != null) {
      _photoStore.delete([_photo!]);
    }
    for (final c in [_store, _subtotal, _tax, _total, _notes]) {
      c.dispose();
    }
    for (final (a, b) in _lines) {
      a.dispose();
      b.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final subtotal = _subtotal.text.trim().isEmpty
        ? null
        : centsFrom(_subtotal);
    await ref
        .read(receiptRepositoryProvider)
        .save(
          ReceiptDraft(
            id: widget.receiptId,
            store: _store.text,
            purchasedAt: _date,
            purpose: _purpose,
            subtotalCents: subtotal,
            taxCents: centsFrom(_tax),
            totalCents: centsFrom(_total),
            photoPath: _photo,
            scannedText: _scannedText,
            notes: _notes.text,
            lines: [for (final (d, a) in _lines) (d.text, centsFrom(a))],
          ),
        );
    _saved = true;
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this receipt?'),
        content: const Text('Its photo is deleted too.'),
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
    final photo = await ref
        .read(receiptRepositoryProvider)
        .delete(widget.receiptId!);
    if (photo != null) await _photoStore.delete([photo]);
    if (mounted) context.pop();
  }

  void _viewPhoto() => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Receipt photo')),
        body: InteractiveViewer(
          maxScale: 6,
          child: Center(child: Image.file(File(_photo!))),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final itemsTotal = _lines.fold(0, (sum, l) => sum + centsFrom(l.$2));
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Receipt' : 'Add receipt'),
        actions: [
          if (_isEdit)
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_photo != null)
              GestureDetector(
                onTap: _viewPhoto,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_photo!),
                    height: 180,
                    fit: BoxFit.cover,
                    cacheWidth: 600,
                    errorBuilder: (_, _, _) => const SizedBox(
                      height: 60,
                      child: Center(child: Text('Photo not found')),
                    ),
                  ),
                ),
              ),
            if (_reading) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
              const SizedBox(height: 4),
              const Text(
                'Reading receipt…',
                style: TextStyle(color: GrimColors.ash),
              ),
            ] else if (_unreadable)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  "Couldn't read everything on this receipt. Check the "
                  'details below and fill in what is missing.',
                  style: TextStyle(color: GrimColors.pyre),
                ),
              )
            else if (!_isEdit && _photo != null)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'Read from your photo. Check it before saving.',
                  style: TextStyle(color: GrimColors.ash),
                ),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _store,
              decoration: const InputDecoration(labelText: 'Store'),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v?.trim() ?? '').isEmpty ? 'Enter the store' : null,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(
                DateFormat.yMMMd().format(_date),
                style: const TextStyle(color: GrimColors.ash),
              ),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: _pickDate,
            ),
            SegmentedButton<ReceiptPurpose>(
              segments: [
                for (final p in ReceiptPurpose.values)
                  ButtonSegment(value: p, label: Text(p.label)),
              ],
              selected: {_purpose},
              showSelectedIcon: false,
              onSelectionChanged: (s) => setState(() => _purpose = s.first),
            ),
            const SizedBox(height: 4),
            Text(
              _purpose == ReceiptPurpose.expense
                  ? 'Also saved as an expense, so it comes out of your profit.'
                  : "Kept for your records. Add the items to inventory so "
                        'their cost counts.',
              style: const TextStyle(color: GrimColors.ash, fontSize: 12),
            ),
            const SizedBox(height: 20),
            Text('Items', style: Theme.of(context).textTheme.titleMedium),
            for (final (i, (description, amount)) in _lines.indexed)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: description,
                        decoration: const InputDecoration(labelText: 'Item'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: MoneyField(
                        controller: amount,
                        label: 'Price',
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remove item',
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() {
                        final (a, b) = _lines.removeAt(i);
                        a.dispose();
                        b.dispose();
                      }),
                    ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(_addLine),
                icon: const Icon(Icons.add),
                label: const Text('Add item'),
              ),
            ),
            if (_lines.isNotEmpty)
              Text(
                'Items add up to ${formatCents(itemsTotal)}',
                style: const TextStyle(color: GrimColors.ash, fontSize: 12),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: MoneyField(controller: _subtotal, label: 'Subtotal'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MoneyField(controller: _tax, label: 'Tax'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            MoneyField(controller: _total, label: 'Total', required: true),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Notes'),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving || _reading ? null : _save,
              child: const Text('Save receipt'),
            ),
          ],
        ),
      ),
    );
  }
}
