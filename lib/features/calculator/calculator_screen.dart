import 'package:flutter/material.dart';

import '../../widgets/empty_state.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Should I buy this?')),
      body: const EmptyState(
        icon: Icons.calculate_outlined,
        title: 'Profit calculator',
        message:
            'Enter what it costs and what it sells for, '
            'and see your real profit after fees on every platform.',
      ),
    );
  }
}
