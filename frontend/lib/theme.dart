import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 Colores base
  static const Color primaryGreen = Color(0xFF0b3d02); // Verde oscuro
  static const Color accentGreen = Colors.green; // Verde claro
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  /// 🌞 Tema Claro
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: white,
    colorScheme: const ColorScheme.light(
      primary: primaryGreen,
      secondary: accentGreen,
      tertiary: Colors.lightGreen,
      onSecondary: white,
      surface: Colors.yellow,
      onSurface: Colors.blue,
      onPrimary: white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: black, fontSize: 16),
      bodyLarge: TextStyle(
        color: black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentGreen,
        foregroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.green),
        foregroundColor: accentGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );

  /// 🌙 Tema Oscuro sin verdes
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF121212), // Muy oscuro gris casi negro
    scaffoldBackgroundColor: const Color(0xFF0A0A0A), // Fondo casi negro
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF212121), // Gris oscuro para elementos primarios
      secondary: Color(0xFF757575),
      tertiary: Color.fromARGB(255, 198, 192, 192), 
      onSecondary: Color(0xFF757575),// Gris medio para acentos
      surface: Colors.yellow,
      onSurface: Colors.blue, // Texto blanco con opacidad
      onPrimary: Colors.white, // Texto blanco botones
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF424242), // Gris oscuro para botones
        foregroundColor: Colors.white, // Texto blanco para botón
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF616161)), // Borde gris medio
        foregroundColor: Colors.white70, // Texto con opacidad
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    
  );
}
