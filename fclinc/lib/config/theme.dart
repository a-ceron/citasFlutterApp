import 'package:flutter/material.dart';

// Definición del tema claro
final lightTheme = ThemeData(
  // Configuración de los colores
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue, // Color base de la paleta
    brightness: Brightness.light, // Brillo del tema
    primary: Colors.blue, // Color primario
    onPrimary: Colors.white, // Color de texto/íconos sobre el color primario
    secondary: Colors.teal, // Color secundario
    onSecondary:
        Colors.white, // Color de texto/íconos sobre el color secundario
    background: const Color(0xFFF5F5F5), // Color de fondo
    onBackground: Colors.black87, // Color de texto/íconos sobre el fondo
    surface: Colors.white, // Color de las superficies (tarjetas, dialogs)
    onSurface: Colors.black87, // Color de texto/íconos sobre las superficies
    error: Colors.red, // Color de error
    onError: Colors.white, // Color de texto/íconos sobre el color de error
  ),

  // Configuración de la tipografía
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 57, fontWeight: FontWeight.bold, color: Colors.black87),
    displayMedium: TextStyle(
        fontSize: 45, fontWeight: FontWeight.bold, color: Colors.black87),
    displaySmall: TextStyle(
        fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
    headlineLarge: TextStyle(
        fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
    headlineMedium: TextStyle(
        fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
    headlineSmall: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
    titleLarge: TextStyle(
        fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
    titleMedium: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
    titleSmall: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
    bodySmall: TextStyle(fontSize: 12, color: Colors.black54),
    labelLarge: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
    labelMedium: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
    labelSmall: TextStyle(
        fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black54),
  ),

  // Configuración de la AppBar
  appBarTheme: const AppBarTheme(
    color: Colors.white, // Color de fondo de la AppBar
    elevation: 0, // Sombra
    iconTheme: IconThemeData(color: Colors.black87), // Color de los íconos
    titleTextStyle: TextStyle(
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  // Configuración de los FloatingActionButton
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blue, // Color de fondo
    foregroundColor: Colors.white, // Color del ícono
  ),

  // Configuración de los botones
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue, // Color de fondo
      foregroundColor: Colors.white, // Color del texto
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),

  // Configuración del card
  cardTheme: const CardThemeData(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),

  // Configuración de los inputs de texto
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.blue, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      // Eliminar el 'const' aquí
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
    filled: true,
    fillColor: Colors.grey.shade200,
    hintStyle: const TextStyle(color: Colors.grey),
  ),
);

// Definition of the dark theme for the FClinic application
final darkTheme = ThemeData(
  // Color Scheme Configuration (Material 3 standard)
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue, // Base color for the palette
    brightness: Brightness.dark, // Theme brightness
    // Dark mode colors
    primary: Colors.lightBlue.shade300, // Primary color
    onPrimary: Colors.black, // Text/icons color on primary
    secondary: Colors.tealAccent.shade200, // Secondary color
    onSecondary: Colors.black, // Text/icons color on secondary
    background: const Color(0xFF121212), // General background color (Deep Dark)
    onBackground: Colors.white, // Text/icons color on background
    surface: const Color(
        0xFF1E1E1E), // Surfaces color (cards, dialogs, slightly lighter than background)
    onSurface: Colors.white70, // Text/icons color on surfaces
    error: Colors.redAccent, // Error color
    onError: Colors.black, // Text/icons color on error
  ),

  // Typography Configuration
  textTheme: TextTheme(
    displayLarge: TextStyle(
        fontSize: 57, fontWeight: FontWeight.bold, color: Colors.white),
    displayMedium: TextStyle(
        fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
    displaySmall: TextStyle(
        fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
    headlineLarge: TextStyle(
        fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: TextStyle(
        fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
    headlineSmall: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    titleLarge: TextStyle(
        fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
    titleMedium: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white70),
    titleSmall: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white70),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    bodySmall: TextStyle(fontSize: 12, color: Colors.white54),
    labelLarge: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
    labelMedium: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
    labelSmall: TextStyle(
        fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white54),
  ),

  // AppBar Configuration
  appBarTheme: AppBarTheme(
    color: const Color(0xFF1E1E1E), // AppBar background color
    elevation: 2, // Shadow
    iconTheme: const IconThemeData(color: Colors.white), // Icons color
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  // FloatingActionButton Configuration
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.lightBlue.shade300, // Background color
    foregroundColor: Colors.black, // Icon color
  ),

  // Elevated Button Configuration
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.lightBlue.shade300, // Background color
      foregroundColor: Colors.black, // Text color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      elevation: 4, // 3D effect elevation
    ),
  ),

  // Text Button Configuration
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.lightBlue.shade300, // Text button color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),

  // Card Configuration
  cardTheme: const CardThemeData(
    // Changed to CardThemeData to match the expected parameter type CardThemeData?
    color: Color(0xFF1E1E1E), // Card background color
    elevation: 4, // Higher elevation
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),

  // Text Input Configuration
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.lightBlue.shade300, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade700),
    ),
    filled: true,
    fillColor: const Color(0xFF2C2C2C), // Input fill color
    hintStyle: const TextStyle(color: Colors.grey),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),

  // Global Shadow Configuration (less aggressive in dark mode)
  shadowColor: Colors.black,
);
