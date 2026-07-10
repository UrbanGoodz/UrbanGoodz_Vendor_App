import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFFED9914);
  static const Color dark = Color(0xFF161616);
  static const Color beige = Color(0xFFE2D3BF);
  static const Color accent = Color(0xFFE5E276);
  static const Color white = Color(0xFFFFFFFF);

  static ThemeData get lightTheme => ThemeData(
        primaryColor: primary,
        scaffoldBackgroundColor: white,
        colorScheme: ColorScheme.light(primary: primary, secondary: accent),
        appBarTheme: const AppBarTheme(
          backgroundColor: dark,
          foregroundColor: white,
        ),
        cardTheme: CardThemeData(
          color: beige.withOpacity(0.3),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: dark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: dark,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(color: dark),
        ),
      );
}
