import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: const Color(0xFFE91E63), // 네온 핑크
    primarySwatch: Colors.pink,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: Colors.white70,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: Colors.white60,
        fontSize: 14,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFFE91E63),
      secondary: const Color(0xFF00E5FF), // 네온 시안
      background: const Color(0xFF121212),
      surface: const Color(0xFF1E1E1E),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
  );

  // 카테고리별 색상
  static Color getCategoryColor(String category) {
    switch (category) {
      case 'live_house':
        return const Color(0xFFE91E63); // 핑크
      case 'pub':
        return const Color(0xFF00E5FF); // 시안
      default:
        return Colors.grey;
    }
  }

  static String getCategoryName(String category) {
    switch (category) {
      case 'live_house':
        return '라이브 공연장';
      case 'pub':
        return '펍';
      default:
        return category;
    }
  }
}