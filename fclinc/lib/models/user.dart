/**
 * Providers/Auth.dart
 * 
 * Permite configurar el provider para 
 * realizar el inicio de sesión de forma
 * exitosa
 */
class User {
  final String firstName;
  final String lastName;
  final String email;
  final String token;
  final int level;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.token,
    this.level = 0, // default if not provided
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      level: json['level'] ?? 0, // default to 0 if missing
    );
  }
}
