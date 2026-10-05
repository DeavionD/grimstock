import 'package:flutter/material.dart';

import '../../widgets/empty_state.dart';

class SoldScreen extends StatelessWidget {
  const SoldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sold')),
      body: const EmptyState(
        icon: Icons.archive_outlined,
        title: 'Nothing sold yet',
        message:
            'Every sale is archived here for good, with where you '
            'bought it, where it sold, and what you made.',
      ),
    );
  }
}
