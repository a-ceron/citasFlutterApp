import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class User {
  final String firstName;
  final String lastName;
  final String email;

  User({required this.firstName, required this.lastName, required this.email});
}

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  String? accessToken;
  bool isLoading = false;
  String? errorMessage;

  User? _user;
  User? get user => _user;

  bool get isLoggedIn => accessToken != null;

  /// Load token from storage
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
        // Invalid token
        accessToken = null;
        _user = null;
        await prefs.remove('access_token');
      }
    }

    isLoading = false;
    notifyListeners();
  }

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
      return true; // success
    } catch (e) {
      // Clear previous token and user
      accessToken = null;
      _user = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');

      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();

      return false; // <-- add this
    }
  }

  /// Logout and clear storage
  Future<void> logout() async {
    accessToken = null;
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');

    notifyListeners();
  }
}
