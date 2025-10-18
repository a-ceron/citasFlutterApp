// lib/config/router.dart
import 'package:fclinc/screens/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/login/login_page.dart';
import '../screens/errors/errors_page.dart';
import '../screens/utils/main_navbar_page.dart';
import '../screens/login/login_google_success_page.dart';

GoRouter createRouter(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    // Seguridad para usuarios no logeados
    redirect: (context, state) {
      final isLoggedIn = authProvider.isLoggedIn;
      final isAtLogin = state.matchedLocation == '/login' ||
          state.matchedLocation == '/login/success';

      if (!isLoggedIn && !isAtLogin) return '/login';
      if (isLoggedIn && isAtLogin) return '/';

      return null; // no redirige
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainNavbarPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/login/success',
        builder: (context, state) => const LoginSuccessPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(state: state),
  );
}
