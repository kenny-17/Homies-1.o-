import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: creamWhite,
    primaryColor: darkMaroon,
    colorScheme: const ColorScheme.light(
      primary: darkMaroon,
      secondary: accentColor,
      background: creamWhite,
      surface: creamWhite,
      onPrimary: creamWhite,
      onSecondary: Colors.black,
      onBackground: Colors.black,
      onSurface: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      color: darkMaroon,
      elevation: 0,
      iconTheme: IconThemeData(color: creamWhite),
      titleTextStyle: TextStyle(
        color: creamWhite,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: darkMaroon, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Colors.black87, height: 1.5),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkMaroon,
        foregroundColor: creamWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
  );
}