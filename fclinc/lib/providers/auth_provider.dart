import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
      final token = await _apiService.login(email, password);
      await _saveToken(token);
      await _loadUser(token);

      _setLoading(false);
      return true;
    } catch (e) {
      await _clearAuth();
      errorMessage = e.toString();
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

  Future<void> _loadUser(String token) async {
    final userData = await _apiService.getMe(token);
    _user = User(
      firstName: userData['first_name'] ?? '',
      lastName: userData['last_name'] ?? '',
      email: userData['email'] ?? '',
    );
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
