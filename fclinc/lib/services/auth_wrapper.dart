/**
 * 
 * 
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/login/login_page.dart';
import '../screens/utils/main_navbar_page.dart';

import '../../../providers/auth_provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (auth.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return auth.isLoggedIn ? const MainNavbarPage() : const LoginPage();
  }
}
