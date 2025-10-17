import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();

  String? _emailError;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        setState(() {
          _emailError = _validateEmail(_emailController.text);
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  String? _validateEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (value.isEmpty) return 'El email es obligatorio';
    if (!emailRegex.hasMatch(value)) return 'Email inválido';
    return null;
  }

  Future<void> _handleLogin() async {
    final auth = context.read<AuthProvider>();

    setState(() {
      _emailError = _validateEmail(_emailController.text);
    });
    if (_emailError != null) return;

    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

    if (success && mounted) {
      context.go('/');
    } else if (mounted) {
      final colorScheme = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text(
            auth.errorMessage ?? 'Error al iniciar sesión',
            style: TextStyle(color: colorScheme.onError),
          ),
          leading: Icon(Icons.error_outline, color: colorScheme.error),
          backgroundColor: colorScheme.error.withOpacity(0.2),
          actions: [
            TextButton(
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: Text('Cerrar', style: TextStyle(color: colorScheme.error)),
            ),
          ],
        ),
      );
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
        final colorScheme = Theme.of(context).colorScheme;
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content: Text(
              'Error Google Login: ${auth.errorMessage ?? e.toString()}',
              style: TextStyle(color: colorScheme.onError),
            ),
            leading: Icon(Icons.error_outline, color: colorScheme.error),
            backgroundColor: colorScheme.error.withOpacity(0.2),
            actions: [
              TextButton(
                onPressed: () =>
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                child:
                    Text('Cerrar', style: TextStyle(color: colorScheme.error)),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Stack(
        children: [
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
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Bienvenido', style: textTheme.headlineMedium),
                        const SizedBox(height: 8),
                        Text('Inicia sesión para continuar',
                            style: textTheme.titleMedium),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            errorText: _emailError,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
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
                        if (auth.isLoading)
                          CircularProgressIndicator(color: colorScheme.primary)
                        else
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 48),
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                ),
                                child: const Text('Login'),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                      child: Divider(
                                          color: colorScheme.onSurface
                                              .withOpacity(0.4))),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child:
                                        Text('O', style: textTheme.bodyMedium),
                                  ),
                                  Expanded(
                                      child: Divider(
                                          color: colorScheme.onSurface
                                              .withOpacity(0.4))),
                                ],
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton.icon(
                                onPressed: _handleGoogleLogin,
                                icon: Image.asset(
                                  'assets/images/google_logo.png',
                                  height: 20,
                                ),
                                label: const Text('Iniciar sesión con Google'),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 48),
                                  foregroundColor: colorScheme.onSurface,
                                  side: BorderSide(color: colorScheme.outline),
                                ),
                              ),
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
