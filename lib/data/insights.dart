import 'item_repository.dart';
import 'sales_repository.dart';

/// Totals for one group of sales, e.g. everything sold on eBay or bought
/// at Nike SNKRS.
class GroupStats {
  GroupStats(this.name);

  String name;
  int sales = 0;
  int units = 0;
  int revenueCents = 0;
  int profitCents = 0;
  int feesCents = 0;
  int costCents = 0;
  int _daysToSell = 0;

  void add(SoldEntry entry) {
    final sale = entry.sale;
    sales++;
    units += sale.quantity;
    revenueCents += sale.salePriceCents;
    profitCents += sale.profitCents;
    feesCents += sale.platformFeesCents;
    costCents += sale.totalCostCents;
    _daysToSell += entry.daysToSell;
  }

  double? get marginPercent =>
      revenueCents == 0 ? null : profitCents / revenueCents * 100;

  double? get roiPercent =>
      costCents == 0 ? null : profitCents / costCents * 100;

  double get averageDaysToSell => sales == 0 ? 0 : _daysToSell / sales;

  int get averageFeesCents => sales == 0 ? 0 : (feesCents / sales).round();
}

/// What the Sold archive says about where to buy and where to sell.
class Insights {
  const Insights({
    required this.totals,
    required this.platforms,
    required this.sources,
    required this.categories,
    required this.brands,
    required this.slowest,
  });

  final GroupStats totals;

  /// Each list is sorted by profit, best first.
  final List<GroupStats> platforms;
  final List<GroupStats> sources;
  final List<GroupStats> categories;
  final List<GroupStats> brands;

  /// Sales that took the longest to sell, slowest first.
  final List<SoldEntry> slowest;

  bool get isEmpty => totals.sales == 0;

  GroupStats? get bestPlatform => platforms.firstOrNull;
  GroupStats? get bestCategory => categories.firstOrNull;

  /// The purchase source with the best return on cost.
  GroupStats? get bestSource {
    final withCost = sources.where((s) => s.roiPercent != null).toList()
      ..sort((a, b) => b.roiPercent!.compareTo(a.roiPercent!));
    return withCost.firstOrNull;
  }
}

/// Groups sales by platform, purchase source, category and brand.
/// [categoryNames] maps category id to name.
Insights buildInsights(
  List<SoldEntry> entries, {
  Map<int, String> categoryNames = const {},
  int slowestCount = 5,
}) {
  final totals = GroupStats('All');
  final platforms = <String, GroupStats>{};
  final sources = <String, GroupStats>{};
  final categories = <String, GroupStats>{};
  final brands = <String, GroupStats>{};

  void addTo(Map<String, GroupStats> groups, String? name, SoldEntry entry) {
    final key = name?.trim() ?? '';
    if (key.isEmpty) return;
    // Brands are typed by hand, so "nike" and "Nike" count together.
    final id = groups == brands ? key.toLowerCase() : key;
    final group = groups.putIfAbsent(id, () => GroupStats(key))..add(entry);
    // Prefer a capitalized spelling, e.g. "Nike" over "nike".
    if (group.name == group.name.toLowerCase()) group.name = key;
  }

  for (final entry in entries) {
    totals.add(entry);
    addTo(platforms, entry.platform?.name, entry);
    addTo(sources, entry.purchaseSource?.name, entry);
    final categoryId = entry.item.categoryId;
    addTo(
      categories,
      categoryId == null ? null : categoryNames[categoryId],
      entry,
    );
    addTo(brands, entry.item.brand, entry);
  }

  List<GroupStats> ranked(Map<String, GroupStats> groups) =>
      groups.values.toList()
        ..sort((a, b) => b.profitCents.compareTo(a.profitCents));

  final slowest = [...entries]
    ..sort((a, b) => b.daysToSell.compareTo(a.daysToSell));

  return Insights(
    totals: totals,
    platforms: ranked(platforms),
    sources: ranked(sources),
    categories: ranked(categories),
    brands: ranked(brands),
    slowest: slowest.take(slowestCount).toList(),
  );
}

/// Date ranges for the dashboard and Insights.
enum Period {
  week('This week'),
  month('This month'),
  year('This year'),
  allTime('All time');

  const Period(this.label);

  final String label;

  /// Where the period starts, or null for all time. Weeks start on Monday.
  DateTime? start(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return switch (this) {
      Period.week => today.subtract(Duration(days: today.weekday - 1)),
      Period.month => DateTime(now.year, now.month),
      Period.year => DateTime(now.year),
      Period.allTime => null,
    };
  }
}

/// Active items bucketed by how long they've sat unsold.
class AgingStock {
  const AgingStock(this.items, this.now);

  /// Active items, oldest first.
  final List<ItemListEntry> items;
  final DateTime now;

  int _count(int from, [int? to]) => items.where((e) {
    final days = e.item.daysInStock(now);
    return days >= from && (to == null || days < to);
  }).length;

  int get days30to59 => _count(30, 60);
  int get days60to89 => _count(60, 90);
  int get days90plus => _count(90);

  /// Items unsold for 30 days or more, oldest first.
  List<ItemListEntry> get stale =>
      items.where((e) => e.item.daysInStock(now) >= 30).toList();
}
