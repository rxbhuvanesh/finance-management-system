import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF0A2540);
  static const Color accent = Color(0xFF22C55E);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.light).copyWith(secondary: accent),
      scaffoldBackgroundColor: const Color(0xFFF4F6F8),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.dark).copyWith(secondary: accent),
    );
  }
}
