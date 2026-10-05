import 'package:flutter/material.dart';

import '../theme/grim_theme.dart';

/// Centered icon, title and message for screens with nothing to show yet.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: GrimColors.mist),
            const SizedBox(height: 16),
            Text(title, style: text.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              message,
              style: text.bodyMedium?.copyWith(color: GrimColors.ash),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
