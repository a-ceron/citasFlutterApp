import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/main_navbar_page.dart'; // Asegúrate de importar la página correcta

class LoginSuccessPage extends StatefulWidget {
  const LoginSuccessPage({super.key});

  @override
  State<LoginSuccessPage> createState() => _LoginSuccessPageState();
}

class _LoginSuccessPageState extends State<LoginSuccessPage> {
  String? _token;
  String? _email;
  String? _firstName;
  String? _lastName;
  String? _error;

  @override
  void initState() {
    super.initState();
    _parseFragment();
  }

  void _parseFragment() async {
    try {
      final href = html.window.location.href;
      final fragmentIndex = href.indexOf('#');

      if (fragmentIndex == -1) {
        setState(() => _error = "No fragment found in URL!");
        return;
      }

      final fragment = href.substring(fragmentIndex + 1);
      final fragUri = Uri.parse(fragment);
      final params = fragUri.queryParameters;

      final token = params['token'];
      final email = params['email'];
      final firstName = params['first_name'];
      final lastName = params['last_name'];

      if (token == null) {
        setState(() => _error = "No token found in URL!");
        return;
      }

      // Guardar token en local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      // Actualizar estado (opcional)
      setState(() {
        _token = token;
        _email = email;
        _firstName = firstName;
        _lastName = lastName;
      });

      // Redirigir automáticamente a MainNavbarPage
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainNavbarPage()),
        );
      }
    } catch (e) {
      setState(() => _error = "Error parsing token: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        body: Center(child: Text(_error!)),
      );
    }

    if (_token == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Este bloque probablemente nunca se vea porque redirigimos
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Logged in as $_firstName $_lastName"),
            Text("Email: $_email"),
            Text("Token: $_token"),
          ],
        ),
      ),
    );
  }
}
