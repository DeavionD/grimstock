import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/money.dart';
import '../../data/database.dart';
import '../../data/expense_repository.dart';
import '../../data/providers.dart';
import '../../theme/grim_theme.dart';
import '../../widgets/empty_state.dart';

/// Business costs that aren't tied to one item, such as supplies,
/// subscriptions and mileage. They come out of dashboard profit.
class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesProvider).value;
    final now = DateTime.now();
    final thisMonth = (expenses ?? const <Expense>[])
        .where((e) => !e.spentAt.isBefore(DateTime(now.year, now.month)))
        .fold(0, (sum, e) => sum + e.amountCents);

    return Scaffold(
      appBar: AppBar(title: const Text('Expenses')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/expenses/new'),
        icon: const Icon(Icons.add),
        label: const Text('Add expense'),
      ),
      body: expenses == null
          ? const SizedBox.shrink()
          : expenses.isEmpty
          ? const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No expenses yet',
              message:
                  'Log supplies, subscriptions, cook groups and mileage so '
                  'your profit is your real profit.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                Text(
                  'This month: ${formatCents(thisMonth)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                for (final expense in expenses)
                  Card(
                    child: ListTile(
                      leading: Icon(
                        expense.expenseKind == ExpenseKind.mileage
                            ? Icons.directions_car_outlined
                            : Icons.receipt_long_outlined,
                        color: GrimColors.hex,
                      ),
                      title: Text(
                        expense.description.isEmpty
                            ? expense.expenseKind.label
                            : expense.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        [
                          expense.expenseKind.label,
                          DateFormat.yMMMd().format(expense.spentAt),
                          if (expense.miles != null)
                            '${_miles(expense.miles!)} mi',
                        ].join(' · '),
                        style: const TextStyle(color: GrimColors.ash),
                      ),
                      trailing: Text(
                        formatCents(expense.amountCents),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      onTap: () => context.push('/expenses/${expense.id}'),
                    ),
                  ),
              ],
            ),
    );
  }

  static String _miles(double miles) =>
      miles == miles.roundToDouble() ? '${miles.round()}' : '$miles';
}
