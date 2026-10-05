import 'package:flutter/material.dart';

import '../../data/database.dart';
import '../../theme/grim_theme.dart';

extension ItemStatusUi on ItemStatus {
  String get label => switch (this) {
    ItemStatus.purchased => 'Purchased',
    ItemStatus.inStock => 'In stock',
    ItemStatus.listed => 'Listed',
    ItemStatus.sold => 'Sold',
    ItemStatus.shipped => 'Shipped',
    ItemStatus.returned => 'Returned',
  };

  Color get color => switch (this) {
    ItemStatus.purchased => GrimColors.ash,
    ItemStatus.inStock => GrimColors.bone,
    ItemStatus.listed => GrimColors.hex,
    ItemStatus.sold || ItemStatus.shipped => GrimColors.ecto,
    ItemStatus.returned => GrimColors.blood,
  };
}

/// Common conditions offered in the form. Users can still type their own.
const conditionOptions = [
  'New',
  'New (no box)',
  'New with defects',
  'Used - Like new',
  'Used - Good',
  'Used - Fair',
];

class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});

  final ItemStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: status.color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
