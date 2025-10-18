import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

/// Provider to manage Google Calendar events
class CalendarProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/calendar.readonly',
    ],
  );

  List<Map<String, dynamic>> _events = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get events => _events;
  bool get isLoading => _isLoading;

  /// Sign in with Google
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      return account;
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      return null;
    }
  }

  /// Fetch events from primary Google Calendar
  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();

    final account = _googleSignIn.currentUser ?? await signInWithGoogle();
    if (account == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final headers = await account.authHeaders;
      final response = await http.get(
        Uri.parse(
            'https://www.googleapis.com/calendar/v3/calendars/primary/events'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _events = (data['items'] as List)
            .map((e) => {
                  'summary': e['summary'] ?? 'Sin título',
                  'start': e['start']['dateTime'] ?? e['start']['date'],
                  'end': e['end']['dateTime'] ?? e['end']['date'],
                })
            .toList();
      } else {
        debugPrint('Failed to fetch events: ${response.body}');
        _events = [];
      }
    } catch (e) {
      debugPrint('Error fetching calendar events: $e');
      _events = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Sign out from Google
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _events = [];
    notifyListeners();
  }
}
