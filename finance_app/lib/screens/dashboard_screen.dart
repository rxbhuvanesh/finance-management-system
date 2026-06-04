import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/finance_provider.dart';
import '../widgets/metric_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardProvider);
    return data.when(
      data: (d) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(spacing: 12, runSpacing: 12, children: [
            MetricCard(title: 'Total Customers', value: '${d['total_customers']}'),
            MetricCard(title: 'Total Loans', value: 'INR ${d['total_loan_amount']}'),
            MetricCard(title: 'Today EMI', value: 'INR ${d['emi_collected_today']}'),
            MetricCard(title: 'Pending', value: 'INR ${d['pending_collections']}'),
          ]),
          const SizedBox(height: 24),
          Card(
            child: SizedBox(
              height: 220,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: LineChart(LineChartData(lineBarsData: [LineChartBarData(spots: const [FlSpot(1, 5), FlSpot(2, 7), FlSpot(3, 6), FlSpot(4, 9)])])),
              ),
            ),
          )
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
