import 'package:flutter/material.dart';

class AppTheme {
  static const Color shahrGreen = Color(0xFF0B7A5C);
  static const Color shahrGreenDark = Color(0xFF075A45);
  static const Color shahrAccent = Color(0xFF00A37A);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: shahrGreen,
      brightness: Brightness.light,
      primary: shahrGreen,
      secondary: shahrAccent,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

