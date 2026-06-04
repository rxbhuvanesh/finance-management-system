import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/finance_provider.dart';

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payments = ref.watch(paymentsProvider);
    return payments.when(
      data: (list) => list.isEmpty
          ? const Center(child: Text('No EMI payments'))
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, i) => Card(
                child: ListTile(
                  title: Text('INR ${list[i].amount}'),
                  subtitle: Text('Loan #${list[i].loanId} | ${list[i].paidOn}'),
                ),
              ),
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
    );
  }
}
