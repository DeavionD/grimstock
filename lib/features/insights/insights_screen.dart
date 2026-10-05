import 'package:flutter/material.dart';

import '../../widgets/empty_state.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: const EmptyState(
        icon: Icons.insights_outlined,
        title: 'No insights yet',
        message:
            'Once you sell a few items, this shows your best platforms, '
            'best places to buy, and what sells fastest.',
      ),
    );
  }
}
