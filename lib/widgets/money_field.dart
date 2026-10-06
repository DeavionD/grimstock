import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/money.dart';

/// A dollar amount input. Empty counts as $0 unless [required] is set.
class MoneyField extends StatelessWidget {
  const MoneyField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.onChanged,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final bool required;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixText: r'$ ',
        suffixIcon: suffixIcon,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      onChanged: onChanged,
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) return required ? 'Required' : null;
        final cents = parseCents(text);
        if (cents == null || cents < 0) return 'Enter an amount like 120.50';
        return null;
      },
    );
  }
}

/// Reads a [MoneyField]'s controller as cents (empty → 0).
int centsFrom(TextEditingController controller) =>
    parseCents(controller.text) ?? 0;

/// Fills a controller from cents, leaving it empty for 0.
String centsText(int cents) =>
    cents == 0 ? '' : (cents / 100).toStringAsFixed(2);
