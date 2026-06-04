import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import 'customers_screen.dart';
import 'dashboard_screen.dart';
import 'loans_screen.dart';
import 'payments_screen.dart';
import 'reports_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _index = 0;
  final _pages = const [DashboardScreen(), CustomersScreen(), LoansScreen(), PaymentsScreen(), ReportsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Management'),
        actions: [IconButton(onPressed: () => ref.read(authProvider.notifier).logout(), icon: const Icon(Icons.logout))],
      ),
      body: AnimatedSwitcher(duration: const Duration(milliseconds: 240), child: _pages[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (v) => setState(() => _index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Customers'),
          NavigationDestination(icon: Icon(Icons.account_balance), label: 'Loans'),
          NavigationDestination(icon: Icon(Icons.payments), label: 'EMI'),
          NavigationDestination(icon: Icon(Icons.insights), label: 'Reports'),
        ],
      ),
    );
  }
}
