import 'package:flutter/material.dart';

import '../../widgets/empty_state.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: const EmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'No stock yet',
        message:
            'Everything you buy to resell will live here, '
            'from purchase to sale.',
      ),
    );
  }
}
