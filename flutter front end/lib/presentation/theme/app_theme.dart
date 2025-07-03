import 'package:flutter/material.dart';

class AppTheme {
  // Mencegah kelas ini diinstansiasi secara tidak sengaja
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.green,
    // Menggunakan warna dari ColorScheme untuk konsistensi
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(
      secondary: const Color(0xFF5E8C61),
      background: const Color(0xFFF0F4F0),
    ),
    scaffoldBackgroundColor: const Color(0xFFF0F4F0),
    fontFamily: 'Poppins', // Pastikan font ini ada di pubspec.yaml
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF5E8C61),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
    ),
    // Tema default untuk semua input field di aplikasi
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF5E8C61), width: 2.0),
      ),
    ),
  );
}
