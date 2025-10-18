/*
  main.dart
  Entry point for the FClinic Flutter Web App.
*/

import 'package:fclinc/providers/google_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'config/theme.dart';
import 'config/router.dart';
import 'providers/auth_provider.dart';

/// Entry point for the Flutter Web App
/// Initializes Flutter engine
/// Clean routes, auth handler and app
/// config
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  final authProvider = AuthProvider();
  await authProvider.loadToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
      ],
      child: const FClinicApp(),
    ),
  );
}

/// Main Widget
class FClinicApp extends StatelessWidget {
  const FClinicApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = createRouter(context);

    return MaterialApp.router(
      title: 'FClinic',
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
