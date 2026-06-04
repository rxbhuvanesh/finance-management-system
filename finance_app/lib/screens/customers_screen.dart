import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/customer_provider.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  String q = '';

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customersProvider(q));
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search customer'),
          onChanged: (v) => setState(() => q = v),
        ),
      ),
      Expanded(
        child: customers.when(
          data: (list) => list.isEmpty
              ? const Center(child: Text('No customers'))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) => Card(child: ListTile(title: Text(list[i].name), subtitle: Text(list[i].mobileNumber))),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
        ),
      ),
    ]);
  }
}
