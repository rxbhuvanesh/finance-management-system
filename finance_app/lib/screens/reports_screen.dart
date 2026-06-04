import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Card(child: ListTile(title: Text('Daily Report'), subtitle: Text('Track today EMI collections'))),
        Card(child: ListTile(title: Text('Weekly Report'), subtitle: Text('7-day finance summary'))),
        Card(child: ListTile(title: Text('Monthly Report'), subtitle: Text('Chart-ready monthly analytics'))),
        Card(child: ListTile(title: Text('Pending Report'), subtitle: Text('Pending EMI and dues'))),
      ],
    );
  }
}
