import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: FinanceApp()));
}

class FinanceApp extends ConsumerStatefulWidget {
  const FinanceApp({super.key});

  @override
  ConsumerState<FinanceApp> createState() => _FinanceAppState();
}

class _FinanceAppState extends ConsumerState<FinanceApp> {
  @override
  void initState() {
    super.initState();
    ref.read(authProvider.notifier).bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    final loggedIn = ref.watch(authProvider);
    return MaterialApp(
      title: 'Finance Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: loggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
