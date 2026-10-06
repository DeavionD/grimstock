import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Product details found for a barcode.
class ProductInfo {
  const ProductInfo({
    required this.title,
    this.brand,
    this.color,
    this.size,
    this.description,
  });

  final String title;
  final String? brand;
  final String? color;
  final String? size;
  final String? description;
}

/// Reads a UPCitemdb lookup response. Returns null when nothing matched.
ProductInfo? parseUpcItemDb(String body) {
  final json = jsonDecode(body);
  if (json is! Map || json['code'] != 'OK') return null;
  final items = json['items'];
  if (items is! List || items.isEmpty) return null;
  final item = items.first as Map;
  String? text(String key) {
    final value = item[key];
    return value is String && value.trim().isNotEmpty ? value.trim() : null;
  }

  final title = text('title');
  if (title == null) return null;
  return ProductInfo(
    title: title,
    brand: text('brand'),
    color: text('color'),
    size: text('size'),
    description: text('description'),
  );
}

/// Looks up UPC and EAN barcodes with UPCitemdb's free trial endpoint
/// (100 lookups a day per device, no key). A paid key is needed before
/// launch; see https://www.upcitemdb.com/wp/docs/main/development/.
class UpcLookup {
  UpcLookup(this.client);

  final http.Client client;

  /// Null when the code isn't a UPC/EAN, nothing matched, or the lookup
  /// failed (offline, rate limited).
  Future<ProductInfo?> lookup(String code) async {
    final digits = code.trim();
    if (!RegExp(r'^\d{8,14}$').hasMatch(digits)) return null;
    try {
      final response = await client
          .get(
            Uri.https('api.upcitemdb.com', '/prod/trial/lookup', {
              'upc': digits,
            }),
          )
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;
      return parseUpcItemDb(response.body);
    } on Exception {
      return null;
    }
  }
}
