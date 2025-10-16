/**
 * screens/login/login_page.dart
 * 
 * Pantalla para el login de la aplicación
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

/// Widget constructor de la pagina
/// Creamos un estado que se esta esperando
/// las acciones dentre del widget
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// Construcción del widget
/// Tenemos metodos que disparan la logica al dar
/// clic en los botones. Tambien los elementos
/// visuales que componen el login
class _LoginPageState extends State<LoginPage> {
  // Definimos las variables
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final auth = context.read<AuthProvider>();

    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      context.go('/dash');
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(auth.errorMessage ?? 'Error al iniciar sesión')),
        );
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    final auth = context.read<AuthProvider>();
    try {
      await auth.loginWithGoogle();
      if (auth.isLoggedIn && mounted) {
        context.go('/dash');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error Google Login: ${auth.errorMessage ?? e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use context.watch to only listen for changes to AuthProvider
    final auth = context.watch<AuthProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 400,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Bienvenido',
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 8),
                        Text('Inicia sesión para continuar',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _passwordController,
                          // La contraseña se oculta si _isPasswordVisible es false
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            // Botón de visibilidad de contraseña
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility // Icono de ojo abierto
                                    : Icons
                                        .visibility_off, // Icono de ojo tachado
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Loading state handled globally for both buttons
                        if (auth.isLoading)
                          const CircularProgressIndicator()
                        else
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: _handleLogin, // Simplified call
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 48),
                                ),
                                child: const Text('Login'),
                              ),
                              const SizedBox(height: 16),
                              // Use const for the entire Row
                              const Row(
                                children: [
                                  Expanded(child: Divider()),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Text('O'),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton.icon(
                                onPressed:
                                    _handleGoogleLogin, // Simplified call
                                icon: Image.asset(
                                  'assets/images/google_logo.png', // Must be added to pubspec.yaml
                                  height: 20,
                                ),
                                label: const Text('Iniciar sesión con Google'),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 48),
                                  foregroundColor: colorScheme.onSurface,
                                  side: BorderSide(color: colorScheme.outline),
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
