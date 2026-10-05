import 'item_repository.dart';

/// Listing styles for the description writer.
enum ListingStyle {
  standard('Standard', 80),
  ebay('eBay', 80),
  short('StockX / GOAT', 60),
  casual('Depop / Poshmark / Mercari', 50);

  const ListingStyle(this.label, this.titleLimit);

  final String label;

  /// Most characters the platform allows in a title.
  final int titleLimit;
}

class Listing {
  const Listing({required this.title, required this.description});

  final String title;
  final String description;
}

/// Writes a listing title and description from an item's fields. Runs on the
/// phone with templates, so it's instant, works offline and costs nothing.
Listing writeListing(ItemDetails details, ListingStyle style) {
  final item = details.item;
  final brand = _clean(item.brand);
  final name = _clean(item.name)!;
  final size = _clean(item.sizeVariant);
  final condition = _clean(item.condition);
  final sku = _clean(item.sku);
  final category = details.category?.name;
  final fields = [
    for (final (field, value) in details.fields)
      if (_clean(value) case final v?) (field.label, v),
  ];
  final isSneaker = category == 'Sneakers';
  final sizeLabel = size == null
      ? null
      : (isSneaker && RegExp(r'^\d').hasMatch(size) ? 'Size $size' : size);

  // Avoid "Nike Nike Dunk" when the name already starts with the brand.
  final brandedName =
      brand == null || name.toLowerCase().startsWith(brand.toLowerCase())
      ? name
      : '$brand $name';
  final styleCode = fields
      .where((f) => f.$1 == 'Style code')
      .map((f) => f.$2)
      .firstOrNull;
  final colorway = fields
      .where((f) => f.$1 == 'Colorway')
      .map((f) => f.$2)
      .firstOrNull;

  final title = switch (style) {
    ListingStyle.ebay => _fit([
      brandedName,
      if (colorway != null && !_contains(name, colorway)) colorway,
      sizeLabel,
      styleCode ?? sku,
      if (condition != null) _shortCondition(condition),
    ], style.titleLimit),
    ListingStyle.short => _fit([brandedName, sizeLabel], style.titleLimit),
    ListingStyle.casual => _fit([brandedName, sizeLabel], style.titleLimit),
    ListingStyle.standard => _fit([
      brandedName,
      sizeLabel,
      if (condition != null) _shortCondition(condition),
    ], style.titleLimit),
  };

  final lines = <String>[
    if (brand != null) 'Brand: $brand',
    if (size != null) 'Size: $size',
    if (condition != null) 'Condition: $condition',
    for (final (label, value) in fields) '$label: $value',
    if (sku != null && sku != styleCode) 'SKU: $sku',
  ];
  final notes = _clean(item.notes);

  final description = switch (style) {
    ListingStyle.short => [
      brandedName,
      ...lines.where((d) => !d.startsWith('Brand:')),
    ].join('\n'),
    ListingStyle.casual => [
      '$brandedName${size == null ? '' : ' in $size'} '
          '${condition == null ? '' : '(${condition.toLowerCase()}) '}'
          '🖤',
      '',
      ...lines,
      if (notes != null) ...['', notes],
      '',
      'Ships fast and packed with care. Feel free to send offers!',
      '',
      _hashtags(brand: brand, name: name, category: category),
    ].join('\n'),
    ListingStyle.ebay || ListingStyle.standard => [
      brandedName,
      '',
      ...lines.map((d) => '• $d'),
      if (notes != null) ...['', notes],
      '',
      [
        if (isSneaker && condition != null && condition.startsWith('New'))
          '100% authentic.',
        'Ships within 1 business day, double boxed.',
        'Message with any questions.',
      ].join(' '),
    ].join('\n'),
  };

  return Listing(title: title, description: description.trim());
}

String? _clean(String? value) {
  final text = value?.trim() ?? '';
  return text.isEmpty ? null : text;
}

bool _contains(String text, String part) =>
    text.toLowerCase().contains(part.toLowerCase());

/// "New (no box)" → "New No Box", "Used - Good" → "Used".
String _shortCondition(String condition) {
  final lower = condition.toLowerCase();
  if (lower == 'new') return 'New';
  if (lower.contains('no box')) return 'New No Box';
  if (lower.startsWith('used')) return 'Used';
  return condition;
}

/// Joins parts with spaces, dropping trailing parts that don't fit [limit].
String _fit(List<String?> parts, int limit) {
  var title = '';
  for (final part in parts.whereType<String>()) {
    final next = title.isEmpty ? part : '$title $part';
    if (next.length > limit) {
      if (title.isEmpty) return part.substring(0, limit).trim();
      continue;
    }
    title = next;
  }
  return title;
}

String _hashtags({String? brand, required String name, String? category}) {
  final tags = <String>{};
  String tag(String text) =>
      '#${text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '')}';
  if (brand != null) tags.add(tag(brand));
  for (final word in name.split(RegExp(r'\s+'))) {
    if (word.length >= 3 && !RegExp(r'^\d+$').hasMatch(word)) {
      tags.add(tag(word));
    }
    if (tags.length >= 5) break;
  }
  if (category != null) tags.add(tag(category));
  tags.add('#resell');
  return tags.where((t) => t.length > 1).join(' ');
}
