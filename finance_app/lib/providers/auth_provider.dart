import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) => AuthNotifier(ref));

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier(this.ref) : super(false);
  final Ref ref;

  Future<bool> login(String username, String password) async {
    final api = ref.read(apiServiceProvider);
    final data = await api.post('/auth/login', {'username': username, 'password': password});
    await api.setToken(data['access_token']);
    state = true;
    return true;
  }

  Future<void> bootstrap() async {
    await ref.read(apiServiceProvider).loadToken();
  }

  Future<void> logout() async {
    await ref.read(apiServiceProvider).setToken('');
    state = false;
  }
}
