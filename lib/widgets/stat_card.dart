import 'package:flutter/material.dart';

import '../theme/grim_theme.dart';

/// A labeled number on the dashboard, e.g. "Profit this month".
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: text.labelMedium?.copyWith(color: GrimColors.ash),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: text.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: valueColor ?? GrimColors.bone,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
