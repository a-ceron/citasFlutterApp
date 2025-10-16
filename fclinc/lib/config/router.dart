// lib/config/router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_wrapper.dart';
import '../providers/auth_provider.dart';
import '../screens/login/login_page.dart';
import '../screens/login/login_google_success_page.dart';
import '../screens/utils/main_navbar_page.dart';
import '../screens/errors/errors_page.dart';

GoRouter createRouter(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authProvider.isLoggedIn;
      final isAtLogin = state.matchedLocation == '/login' ||
          state.matchedLocation.startsWith('/login/success');

      if (!isLoggedIn && !isAtLogin) return '/login';
      if (isLoggedIn && isAtLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthWrapper(),
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
        path: '/main',
        builder: (context, state) => const MainNavbarPage(),
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(state: state),
  );
}
