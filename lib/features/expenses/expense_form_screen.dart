import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/money.dart';
import '../../data/expense_repository.dart';
import '../../data/providers.dart';
import '../../theme/grim_theme.dart';
import '../../widgets/money_field.dart';

/// Add an expense ([expenseId] null) or edit one.
class ExpenseFormScreen extends ConsumerStatefulWidget {
  const ExpenseFormScreen({super.key, this.expenseId});

  final int? expenseId;

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final _amount = TextEditingController();
  final _miles = TextEditingController();
  ExpenseKind _kind = ExpenseKind.supplies;
  DateTime _spentAt = DateTime.now();
  bool _saving = false;

  bool get _isEdit => widget.expenseId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _load();
  }

  Future<void> _load() async {
    final expense = await ref
        .read(expenseRepositoryProvider)
        .watchExpense(widget.expenseId!)
        .first;
    if (!mounted || expense == null) return;
    setState(() {
      _description.text = expense.description;
      _amount.text = centsText(expense.amountCents);
      _miles.text = expense.miles == null ? '' : '${expense.miles}';
      _kind = expense.expenseKind;
      _spentAt = expense.spentAt;
    });
  }

  @override
  void dispose() {
    _description.dispose();
    _amount.dispose();
    _miles.dispose();
    super.dispose();
  }

  double? get _milesValue => double.tryParse(_miles.text.trim());

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _spentAt,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
    );
    if (picked != null) setState(() => _spentAt = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await ref
        .read(expenseRepositoryProvider)
        .save(
          ExpenseDraft(
            id: widget.expenseId,
            description: _description.text,
            kind: _kind,
            spentAt: _spentAt,
            amountCents: centsFrom(_amount),
            miles: _milesValue,
          ),
        );
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this expense?'),
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
    await ref.read(expenseRepositoryProvider).delete(widget.expenseId!);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final rate =
        ref.watch(mileageRateProvider).value ?? defaultMileageRateCents;
    final isMileage = _kind == ExpenseKind.mileage;
    final miles = _milesValue;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit expense' : 'Add expense'),
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
            DropdownButtonFormField<ExpenseKind>(
              initialValue: _kind,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Kind'),
              items: [
                for (final kind in ExpenseKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (kind) => setState(() => _kind = kind!),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              decoration: InputDecoration(
                labelText: isMileage ? 'Trip (optional)' : 'What was it?',
                hintText: isMileage
                    ? 'e.g. Outlet run'
                    : 'e.g. Shoe boxes, cook group',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            if (isMileage)
              TextFormField(
                controller: _miles,
                decoration: InputDecoration(
                  labelText: 'Miles',
                  helperText: miles == null
                      ? 'At $rate¢ a mile (IRS 2026 rate)'
                      : '${formatCents((miles * rate).round())} at $rate¢ a mile',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  final value = double.tryParse(v?.trim() ?? '');
                  return value == null || value <= 0
                      ? 'Enter the miles driven'
                      : null;
                },
              )
            else
              MoneyField(controller: _amount, label: 'Amount', required: true),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(
                DateFormat.yMMMd().format(_spentAt),
                style: const TextStyle(color: GrimColors.ash),
              ),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
