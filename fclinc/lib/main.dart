/*
  main.dart
  Construcción del wigget mainApp para
  la creación de la aplicación web
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'services/auth_wrapper.dart';
import 'screens/login/login_google_success_page.dart';
import 'config/theme.dart';

/*
  Construcción de la aplicación a partir de la 
  instancia de widget FClinicAPP que contiene la 
  estructura inicial de la aplicación.
 */
void main() {
  runApp(const FClinicApp());
}

/**
  Clase construcutra. No mutable
  Nombre de la pagina: FCLinic
  Tema: lightTheme
  home: AuthWrapper()
 */
class FClinicApp extends StatelessWidget {
  const FClinicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: MaterialApp(
          title: 'FClinic',
          theme: lightTheme,
          home: const AuthWrapper(),
          onGenerateRoute: (settings) {
            final uri = Uri.parse(settings.name!);
            if (uri.path == '/login/success') {
              return MaterialPageRoute(
                builder: (_) => const LoginSuccessPage(),
              );
            }
            return MaterialPageRoute(builder: (_) => const AuthWrapper());
          },
        ));
  }
}
