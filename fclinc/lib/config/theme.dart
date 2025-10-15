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
