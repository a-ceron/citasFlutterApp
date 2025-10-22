/**
 * Providers/Auth.dart
 * 
 * Permite configurar el provider para 
 * realizar el inicio de sesión de forma
 * exitosa
 */
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/api_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool isLoading = false;
  String? accessToken;
  String? errorMessage;
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => accessToken != null;

  /// 🔹 Carga token y usuario al iniciar la app
  Future<void> loadToken() async {
    _setLoading(true);

    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token');

    if (accessToken != null) {
      try {
        await _loadUser(accessToken!);
      } catch (_) {
        await _clearAuth();
      }
    }

    _setLoading(false);
  }

  /// 🔹 Redirige a Google OAuth (moderno, sin dart:html)
  Future<void> loginWithGoogle() async {
    const clientId =
        '269587646329-6vragflvdhklni3q8j8m3irv2o705epf.apps.googleusercontent.com';
    const redirectUri = 'http://127.0.0.1:5000/auth/callback';

    final authUrl = Uri.parse(
      'https://accounts.google.com/o/oauth2/v2/auth'
      '?response_type=code'
      '&client_id=$clientId'
      '&redirect_uri=$redirectUri'
      '&scope=openid%20email%20profile'
      '&access_type=offline'
      '&prompt=consent',
    );

    // Abre la URL de login en una nueva pestaña o app externa
    if (!await launchUrl(authUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir la URL de login');
    }
  }

  /// 🔹 Maneja callback de Google
  Future<void> handleGoogleLoginSuccess({required String token}) async {
    if (token.isEmpty) throw Exception('Token vacío recibido');

    await _saveToken(token);
    try {
      await _loadUser(token);
    } catch (_) {
      await _clearAuth();
      rethrow;
    }
  }

  /// 🔹 Login normal email/password
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    errorMessage = null;

    try {
      final userData = await _apiService.login(email, password);
      await _saveToken(userData['access_token']);
      await _loadUser(userData);
      await _saveRole(userData['user']['level']);

      _setLoading(false);
      return true;
    } catch (e) {
      await _clearAuth();

      // ------------------------------------------------------------------
      // MODIFICACIÓN: Extraer un mensaje de error limpio y legible.
      // ------------------------------------------------------------------
      String errorText = e.toString();

      // 1. Remueve el prefijo "Exception: " si está presente.
      if (errorText.startsWith('Exception: ')) {
        errorText = errorText.replaceFirst('Exception: ', '');
      }

      // 2. Establece el mensaje de error.
      errorMessage = errorText;

      _setLoading(false);
      return false;
    }
  }

  /// 🔹 Logout
  Future<void> logout() async {
    await _clearAuth();
  }

  /// 🔹 PRIVATE METHODS
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    accessToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<void> _saveRole(int role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('level', role);
  }

  Future<void> _loadUser(final userData) async {
    _user = User(
        firstName: userData['user']['first_name'] ?? '',
        lastName: userData['user']['last_name'] ?? '',
        email: userData['user']['email'] ?? '',
        token: userData['access_token'] ?? '',
        level: userData['user']['level'] ?? 0);
    notifyListeners();
  }

  Future<void> _clearAuth() async {
    accessToken = null;
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');

    notifyListeners();
  }
}
