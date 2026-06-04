import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/finance_provider.dart';

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loans = ref.watch(loansProvider);
    return loans.when(
      data: (list) => list.isEmpty
          ? const Center(child: Text('No loans'))
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, i) => Card(
                child: ListTile(
                  title: Text('Loan #${list[i].id} - INR ${list[i].principalAmount}'),
                  subtitle: Text('EMI: ${list[i].emiDurationMonths} months | Due Day: ${list[i].dueDay}'),
                ),
              ),
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
    );
  }
}
