import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFFFC1CC); // 연한 핑크
  static const Color secondaryColor = Color(0xFFB8E6B8); // 연한 민트
  static const Color backgroundColor = Color(0xFFFFF9F9); // 매우 연한 핑크 배경
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF4A4A4A);
  static const Color subtitleColor = Color(0xFF9E9E9E);
  
  static const Color happyColor = Color(0xFFFFE4B5); // 연한 피치
  static const Color joyColor = Color(0xFFFFDAB9); // 연한 살구
  static const Color neutralColor = Color(0xFFE6E6FA); // 연한 라벤더
  static const Color sadColor = Color(0xFFB0C4DE); // 연한 블루
  static const Color angryColor = Color(0xFFFFB6C1); // 라이트 핑크

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundColor,
      surface: cardColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Pretendard',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: const TextStyle(color: subtitleColor),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: subtitleColor,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: subtitleColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
    ),
  );
}