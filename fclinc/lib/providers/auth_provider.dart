import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';

class User {
  final String firstName;
  final String lastName;
  final String email;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
  });
}

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool isLoading = false;
  String? accessToken;
  String? errorMessage;
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => accessToken != null;

  /// 🔹 Carga el token desde almacenamiento local y obtiene datos del usuario
  Future<void> loadToken() async {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token');

    if (accessToken != null) {
      try {
        final userData = await _apiService.getMe(accessToken!);
        _user = User(
          firstName: userData['first_name'] ?? '',
          lastName: userData['last_name'] ?? '',
          email: userData['email'] ?? '',
        );
      } catch (e) {
        // Si el token ya no es válido, se limpia
        accessToken = null;
        _user = null;
        await prefs.remove('access_token');
      }
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔹 Inicia el flujo de login con Google (solo redirige)
  Future<void> loginWithGoogle() async {
    const clientId =
        '269587646329-6vragflvdhklni3q8j8m3irv2o705epf.apps.googleusercontent.com';
    const redirectUri = 'http://127.0.0.1:5000/auth/callback';

    final authUrl = 'https://accounts.google.com/o/oauth2/v2/auth'
        '?response_type=code'
        '&client_id=$clientId'
        '&redirect_uri=$redirectUri'
        '&scope=openid%20email%20profile'
        '&access_type=offline'
        '&prompt=consent';

    html.window.location.href = authUrl;
  }

  /// 🔹 Maneja el retorno desde Google (recibe token, obtiene user info)
  Future<void> handleGoogleLoginSuccess({required String token}) async {
    if (token.isEmpty) {
      throw Exception('Token vacío recibido del callback');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    accessToken = token;

    try {
      // Llama a tu backend para obtener info del usuario
      final userData = await _apiService.getMe(token);
      _user = User(
        firstName: userData['first_name'] ?? '',
        lastName: userData['last_name'] ?? '',
        email: userData['email'] ?? '',
      );
      notifyListeners();
    } catch (e) {
      // Si algo falla, limpia el token
      accessToken = null;
      _user = null;
      await prefs.remove('access_token');
      rethrow;
    }
  }

  /// 🔹 Login normal (email / password)
  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = await _apiService.login(email, password);
      accessToken = token;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token);

      final userData = await _apiService.getMe(token);
      _user = User(
        firstName: userData['first_name'] ?? '',
        lastName: userData['last_name'] ?? '',
        email: userData['email'] ?? '',
      );

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      accessToken = null;
      _user = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');

      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// 🔹 Cierra sesión y limpia almacenamiento local
  Future<void> logout() async {
    accessToken = null;
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');

    notifyListeners();
  }
}
