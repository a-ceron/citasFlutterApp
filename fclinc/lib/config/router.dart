// lib/config/router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_wrapper.dart';
import '../providers/auth_provider.dart';
import '../screens/login/login_page.dart';
import '../screens/login/login_google_success_page.dart';
import '../screens/dash/dash_page.dart';
import '../screens/clients/client_page.dart';
import '../screens/employee/employees_page.dart';
import '../screens/procedures/procedure_page.dart';
import '../screens/records/records_page.dart';
import '../screens/errors/errors_page.dart';

/// Builds the router with automatic redirection based on authentication.
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
      if (isLoggedIn && isAtLogin) return '/dash';
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
        path: '/dash',
        builder: (context, state) => const DashPage(),
      ),
      GoRoute(
        path: '/clients',
        builder: (context, state) => const ClientsPage(),
      ),
      GoRoute(
        path: '/employees',
        builder: (context, state) => const EmployeesPage(),
      ),
      GoRoute(
        path: '/procedures',
        builder: (context, state) => const ProceduresPage(),
      ),
      GoRoute(
        path: '/records',
        builder: (context, state) => const RecordsPage(),
      ),
    ],
    // Updated errorBuilder to use the dedicated ErrorPage component
    errorBuilder: (context, state) => ErrorPage(state: state),
  );
}
