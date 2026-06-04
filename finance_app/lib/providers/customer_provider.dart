import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/customer.dart';
import 'auth_provider.dart';

final customersProvider = FutureProvider.family<List<Customer>, String?>((ref, search) async {
  final api = ref.read(apiServiceProvider);
  final data = await api.get('/customers', query: search == null || search.isEmpty ? null : {'search': search});
  return (data as List).map((e) => Customer.fromJson(e)).toList();
});
