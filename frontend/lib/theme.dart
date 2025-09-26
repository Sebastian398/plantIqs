import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark( 
      primary: Color(0XFFDA00FF), 
      secondary: Color(0xFF7E0FF5),
      surface: Color(0xFF2B2F3A),
      onPrimary: Colors.white, 
      onSecondary: Colors.white, 
      onSurface: Color(0xFFE3E3E3),
      tertiary: Color(0xFFE3E3E3),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFE3E3E3), fontSize: 16),
      bodyMedium: TextStyle(color: Color(0xFFE3E3E3), fontSize: 16, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color:Color(0xFFE3E3E3), fontSize: 20, fontWeight: FontWeight.bold),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF1C1F2A),
      labelStyle: TextStyle(color: Color(0xFFE3E3E3)),
      prefixIconColor: Color(0xFFE3E3E3), 
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    ),
    
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light( 
      primary: Color(0xFF0BE4AC),
      secondary: Color(0xFF0AB5DD),
      surface: Colors.white,  
      onPrimary: Colors.white, 
      onSecondary: Colors.white,
      onSurface: Color(0xFF1C1F2A),
      tertiary: Colors.black45,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF5F5F5),
      labelStyle: TextStyle(color: Colors.black87 ),
      prefixIconColor: Colors.black54, 
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    ),
    
  );
}