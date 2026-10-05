import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/database.dart';
import '../../data/item_repository.dart';
import '../../data/providers.dart';
import '../../theme/grim_theme.dart';
import '../../widgets/money_field.dart';
import '../../widgets/suggest_field.dart';
import '../pro/paywall_screen.dart';
import 'item_status_ui.dart';
import 'scanner_screen.dart';

/// Costs carried over from the calculator into a new item.
class ItemPrefill {
  const ItemPrefill({
    this.purchasePriceCents = 0,
    this.purchaseTaxCents = 0,
    this.inboundShippingCents = 0,
  });

  final int purchasePriceCents;
  final int purchaseTaxCents;
  final int inboundShippingCents;
}

/// Add a new item ([itemId] null) or edit an existing one.
class ItemFormScreen extends ConsumerStatefulWidget {
  const ItemFormScreen({super.key, this.itemId, this.prefill});

  final int? itemId;
  final ItemPrefill? prefill;

  @override
  ConsumerState<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends ConsumerState<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _brand = TextEditingController();
  final _size = TextEditingController();
  final _condition = TextEditingController();
  final _sku = TextEditingController();
  final _quantity = TextEditingController(text: '1');
  final _source = TextEditingController();
  final _storage = TextEditingController();
  final _notes = TextEditingController();
  final _price = TextEditingController();
  final _tax = TextEditingController();
  final _inbound = TextEditingController();
  final _other = TextEditingController();

  int? _categoryId;
  ItemStatus _status = ItemStatus.inStock;
  DateTime? _purchaseDate = DateTime.now();
  List<CategoryField> _fields = const [];
  final Map<int, TextEditingController> _fieldControllers = {};
  bool _loading = false;
  bool _saving = false;

  bool get _isEdit => widget.itemId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _loadItem();
    final prefill = widget.prefill;
    if (prefill != null) {
      _price.text = centsText(prefill.purchasePriceCents);
      _tax.text = centsText(prefill.purchaseTaxCents);
      _inbound.text = centsText(prefill.inboundShippingCents);
    }
  }

  Future<void> _loadItem() async {
    setState(() => _loading = true);
    final details = await ref
        .read(itemRepositoryProvider)
        .watchItem(widget.itemId!)
        .first;
    if (!mounted || details == null) return;
    final item = details.item;
    _name.text = item.name;
    _brand.text = item.brand ?? '';
    _size.text = item.sizeVariant ?? '';
    _condition.text = item.condition ?? '';
    _sku.text = item.sku ?? '';
    _quantity.text = '${item.quantity}';
    _source.text = details.purchaseSource?.name ?? '';
    _storage.text = item.storageLocation ?? '';
    _notes.text = item.notes ?? '';
    _price.text = centsText(item.purchasePriceCents);
    _tax.text = centsText(item.purchaseTaxCents);
    _inbound.text = centsText(item.inboundShippingCents);
    _other.text = centsText(item.otherCostsCents);
    _status = item.status;
    _purchaseDate = item.purchaseDate;
    _categoryId = item.categoryId;
    _fields = [for (final (field, _) in details.fields) field];
    for (final (field, value) in details.fields) {
      _controllerFor(field).text = value ?? '';
    }
    setState(() => _loading = false);
  }

  TextEditingController _controllerFor(CategoryField field) =>
      _fieldControllers.putIfAbsent(field.id, TextEditingController.new);

  Future<void> _selectCategory(int? id) async {
    setState(() => _categoryId = id);
    final fields = id == null
        ? const <CategoryField>[]
        : await ref.read(itemRepositoryProvider).getCategoryFields(id);
    if (mounted) setState(() => _fields = fields);
  }

  Future<void> _scan() async {
    final code = await Navigator.of(context)
        .push<String>(MaterialPageRoute(builder: (_) => const ScannerScreen()));
    if (code == null || !mounted) return;
    setState(() => _sku.text = code);
    if (!ref.read(isProProvider)) return;

    // Pro: fill the name and brand from the barcode when they're empty.
    final info = await ref.read(upcLookupProvider).lookup(code);
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    if (info == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('No product found for that barcode')),
      );
      return;
    }
    setState(() {
      if (_name.text.trim().isEmpty) _name.text = info.title;
      if (_brand.text.trim().isEmpty && info.brand != null) {
        _brand.text = info.brand!;
      }
    });
    messenger.showSnackBar(
      SnackBar(content: Text('Filled in from barcode: ${info.title}')),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
    );
    if (picked != null) setState(() => _purchaseDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final draft = ItemDraft(
      id: widget.itemId,
      name: _name.text,
      categoryId: _categoryId,
      brand: _brand.text,
      sizeVariant: _size.text,
      condition: _condition.text,
      sku: _sku.text,
      quantity: int.tryParse(_quantity.text) ?? 1,
      status: _status,
      purchaseDate: _purchaseDate,
      purchaseSourceName: _source.text,
      storageLocation: _storage.text,
      notes: _notes.text,
      purchasePriceCents: centsFrom(_price),
      purchaseTaxCents: centsFrom(_tax),
      inboundShippingCents: centsFrom(_inbound),
      otherCostsCents: centsFrom(_other),
      fieldValues: {
        for (final field in _fields) field.id: _controllerFor(field).text,
      },
    );
    try {
      final id = await ref.read(itemRepositoryProvider).saveItem(draft);
      if (!mounted) return;
      if (_isEdit) {
        context.pop();
      } else {
        context.pushReplacement('/inventory/$id');
      }
    } on FreeLimitReached catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        await showFreeLimitDialog(context, e.limit);
      }
    }
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _brand,
      _size,
      _condition,
      _sku,
      _quantity,
      _source,
      _storage,
      _notes,
      _price,
      _tax,
      _inbound,
      _other,
      ..._fieldControllers.values,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final sources = ref.watch(purchaseSourcesProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit item' : 'Add item'),
        actions: [
          TextButton(
            onPressed: _saving || _loading ? null : _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: 'Item name',
                      hintText: 'e.g. Jordan 4 Retro Bred Reimagined',
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => (v?.trim().isEmpty ?? true)
                        ? 'Give the item a name'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int?>(
                    initialValue: _categoryId,
                    decoration: const InputDecoration(labelText: 'Category'),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(value: null, child: Text('None')),
                      for (final c in categories)
                        DropdownMenuItem(value: c.id, child: Text(c.name)),
                    ],
                    onChanged: _selectCategory,
                  ),
                  const SizedBox(height: 12),
                  _row(
                    TextFormField(
                      controller: _brand,
                      decoration: const InputDecoration(labelText: 'Brand'),
                      textCapitalization: TextCapitalization.words,
                    ),
                    TextFormField(
                      controller: _size,
                      decoration: const InputDecoration(
                        labelText: 'Size / variant',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SuggestField(
                    controller: _condition,
                    options: conditionOptions,
                    label: 'Condition',
                  ),
                  for (final field in _fields) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _controllerFor(field),
                      decoration: InputDecoration(labelText: field.label),
                    ),
                  ],
                  const SizedBox(height: 12),
                  _row(
                    TextFormField(
                      controller: _sku,
                      decoration: InputDecoration(
                        labelText: 'SKU / barcode',
                        suffixIcon: IconButton(
                          tooltip: 'Scan barcode',
                          icon: const Icon(Icons.qr_code_scanner),
                          onPressed: _scan,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _quantity,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        final n = int.tryParse(v ?? '');
                        return n == null || n < 1 ? 'At least 1' : null;
                      },
                    ),
                    flexes: (3, 2),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<ItemStatus>(
                    initialValue: _status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    isExpanded: true,
                    items: [
                      // Sold and Shipped are set by recording a sale, not here.
                      for (final s in ItemStatus.values)
                        if (activeStatuses.contains(s) || s == _status)
                          DropdownMenuItem(value: s, child: Text(s.label)),
                    ],
                    onChanged: (s) => setState(() => _status = s ?? _status),
                  ),
                  _section('What you paid (per item)'),
                  _row(
                    MoneyField(controller: _price, label: 'Price paid'),
                    MoneyField(controller: _tax, label: 'Tax'),
                  ),
                  const SizedBox(height: 12),
                  _row(
                    MoneyField(controller: _inbound, label: 'Shipping to you'),
                    MoneyField(controller: _other, label: 'Other costs'),
                  ),
                  _section('Where and when'),
                  SuggestField(
                    controller: _source,
                    options: [for (final s in sources) s.name],
                    label: 'Bought from',
                    hint: 'e.g. Nike SNKRS, Foot Locker, Goodwill',
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Purchase date'),
                    subtitle: Text(
                      _purchaseDate == null
                          ? 'Not set'
                          : DateFormat.yMMMd().format(_purchaseDate!),
                      style: const TextStyle(color: GrimColors.ash),
                    ),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: _pickDate,
                  ),
                  TextFormField(
                    controller: _storage,
                    decoration: const InputDecoration(
                      labelText: 'Storage location',
                      hintText: 'e.g. Closet shelf 2',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _notes,
                    decoration: const InputDecoration(labelText: 'Notes'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    child: Text(_isEdit ? 'Save changes' : 'Add to inventory'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _row(Widget a, Widget b, {(int, int) flexes = (1, 1)}) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(flex: flexes.$1, child: a),
      const SizedBox(width: 12),
      Expanded(flex: flexes.$2, child: b),
    ],
  );

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 24, 0, 12),
    child: Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelMedium
          ?.copyWith(color: GrimColors.ecto, letterSpacing: 1.2),
    ),
  );
}

/// Explains the free plan limit. The Pro upgrade lands with the paywall in
/// milestone 5.
Future<void> showFreeLimitDialog(BuildContext context, int limit) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Your stock is full'),
      content: Text(
        'The free plan holds $limit active items. Sell or archive something, '
        'or upgrade to Pro for unlimited items.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Not now'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            showPaywall(context);
          },
          child: const Text('See Pro'),
        ),
      ],
    ),
  );
}
