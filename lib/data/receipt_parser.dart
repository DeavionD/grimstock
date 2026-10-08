/// What could be read off a receipt. Every field is a best guess for the
/// user to check before saving.
class ParsedReceipt {
  const ParsedReceipt({
    this.store,
    this.date,
    this.subtotalCents,
    this.taxCents,
    this.totalCents,
    this.lines = const [],
  });

  final String? store;
  final DateTime? date;
  final int? subtotalCents;
  final int? taxCents;
  final int? totalCents;
  final List<(String, int)> lines;
}

final _amountAtEnd = RegExp(
  r'(-)?\$?\s*(\d{1,3}(?:,\d{3})+|\d+)[.,](\d{2})\s*[A-Z]{0,2}\s*$',
);

const _months = {
  'jan': 1,
  'feb': 2,
  'mar': 3,
  'apr': 4,
  'may': 5,
  'jun': 6,
  'jul': 7,
  'aug': 8,
  'sep': 9,
  'oct': 10,
  'nov': 11,
  'dec': 12,
};

/// Lines that carry an amount but aren't something that was bought.
final _notAnItem = RegExp(
  r'total|tax|change|cash|tender|visa|master|amex|discover|debit|credit|'
  r'card|balance|payment|paid|due|savings|you saved|refund|auth|approval|'
  r'tip|gratuity|points|rewards',
  caseSensitive: false,
);

/// Reads store, date, subtotal, tax, total and line items from receipt
/// text (as returned by on-device text recognition, one line per row).
ParsedReceipt parseReceipt(String text, {DateTime? now}) {
  final rows = text
      .split('\n')
      .map((l) => l.replaceAll(RegExp(r'\s+'), ' ').trim())
      .where((l) => l.isNotEmpty)
      .toList();

  int? subtotal;
  int? tax;
  int? total;
  final amounts = <int>[];
  final lines = <(String, int)>[];

  for (final row in rows) {
    final match = _amountAtEnd.firstMatch(row);
    if (match == null) continue;
    final cents =
        int.parse(match.group(2)!.replaceAll(',', '')) * 100 +
        int.parse(match.group(3)!);
    final amount = match.group(1) == null ? cents : -cents;
    final label = row.substring(0, match.start).trim();
    final lower = label.toLowerCase();
    amounts.add(amount);

    if (RegExp(r'sub\s*-?\s*total').hasMatch(lower)) {
      subtotal ??= amount;
    } else if (RegExp(r'\btax\b|\bhst\b|\bgst\b|\bvat\b').hasMatch(lower) &&
        !lower.contains('total')) {
      tax = (tax ?? 0) + amount;
    } else if (RegExp(r'grand total|^total|\btotal\b|amount due|balance due')
        .hasMatch(lower)) {
      // The first total is usually the receipt total; later ones repeat it
      // next to the payment.
      total ??= amount;
    } else if (!_notAnItem.hasMatch(lower) &&
        RegExp('[A-Za-z]{2,}').hasMatch(label)) {
      lines.add((_cleanItem(label), amount));
    }
  }

  total ??= amounts.isEmpty ? null : amounts.reduce((a, b) => a > b ? a : b);
  if (subtotal == null && total != null && tax != null) {
    subtotal = total - tax;
  }

  return ParsedReceipt(
    store: _store(rows),
    date: _date(rows, now ?? DateTime.now()),
    subtotalCents: subtotal,
    taxCents: tax,
    totalCents: total,
    lines: lines,
  );
}

/// The first line with real words, which is usually the store's name.
String? _store(List<String> rows) {
  for (final row in rows.take(6)) {
    final letters = RegExp('[A-Za-z]').allMatches(row).length;
    if (letters < 3 || letters < row.length / 2) continue;
    if (RegExp(r'receipt|welcome|thank', caseSensitive: false).hasMatch(row)) {
      continue;
    }
    return row;
  }
  return null;
}

DateTime? _date(List<String> rows, DateTime now) {
  DateTime? valid(int year, int month, int day) {
    if (year < 100) year += 2000;
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    final date = DateTime(year, month, day);
    // Ignore misreads that land in the future or long ago.
    if (date.isAfter(now) || year < now.year - 10) return null;
    return date.month == month ? date : null;
  }

  for (final row in rows) {
    final iso = RegExp(r'\b(\d{4})[-/.](\d{1,2})[-/.](\d{1,2})\b')
        .firstMatch(row);
    if (iso != null) {
      final d = valid(
        int.parse(iso.group(1)!),
        int.parse(iso.group(2)!),
        int.parse(iso.group(3)!),
      );
      if (d != null) return d;
    }
    final us = RegExp(r'\b(\d{1,2})[-/.](\d{1,2})[-/.](\d{4}|\d{2})\b')
        .firstMatch(row);
    if (us != null) {
      final d = valid(
        int.parse(us.group(3)!),
        int.parse(us.group(1)!),
        int.parse(us.group(2)!),
      );
      if (d != null) return d;
    }
    final named = RegExp(
      r'\b(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\.? (\d{1,2}),? (\d{4})\b',
      caseSensitive: false,
    ).firstMatch(row);
    if (named != null) {
      final d = valid(
        int.parse(named.group(3)!),
        _months[named.group(1)!.toLowerCase()]!,
        int.parse(named.group(2)!),
      );
      if (d != null) return d;
    }
  }
  return null;
}

/// Drops leading item codes and quantities like "0004000 2 @" so the
/// description reads cleanly.
String _cleanItem(String label) {
  final cleaned = label
      .replaceFirst(RegExp(r'^\d{4,}\s+'), '')
      .replaceFirst(RegExp(r'\s+\d+\s*@\s*$'), '')
      .trim();
  return cleaned.isEmpty ? label : cleaned;
}
