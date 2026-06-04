import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/loan.dart';
import '../models/payment.dart';
import 'auth_provider.dart';

final loansProvider = FutureProvider<List<Loan>>((ref) async {
  final data = await ref.read(apiServiceProvider).get('/loans');
  return (data as List).map((e) => Loan.fromJson(e)).toList();
});

final paymentsProvider = FutureProvider<List<Payment>>((ref) async {
  final data = await ref.read(apiServiceProvider).get('/payments');
  return (data as List).map((e) => Payment.fromJson(e)).toList();
});

final dashboardProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return Map<String, dynamic>.from(await ref.read(apiServiceProvider).get('/reports/dashboard'));
});
