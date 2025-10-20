// lib/screens/profile/profile_page.dart
import 'package:fclinc/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../providers/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSyncing = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<void> _syncWithGoogle() async {
    setState(() => _isSyncing = true);
    final api = ApiService();

    try {
      // Paso 1: Login con Google
      final account = await _googleSignIn.signIn();
      if (account == null) {
        // El usuario canceló el login
        setState(() => _isSyncing = false);
        return;
      }

      // Paso 2: Obtener token de acceso
      final auth = await account.authentication;
      final token = auth.idToken;

      // Paso 3: Enviar token al backend
      Future<bool> response = api.postGoogleToken(token!);

      if (await response) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cuenta sincronizada correctamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al sincronizar la cuenta')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final theme = Theme.of(context);

    String initials() {
      if (user?.firstName.isNotEmpty == true) {
        return user!.firstName[0].toUpperCase();
      }
      return 'U';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: Text(
                initials(),
                style: theme.textTheme.headlineMedium
                    ?.copyWith(color: theme.colorScheme.primary),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.firstName ?? 'Usuario',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? 'correo@ejemplo.com',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.sync),
                      title: const Text('Sincronizar con Google'),
                      trailing: _isSyncing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: _syncWithGoogle,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Editar nombre'),
                      subtitle: Text(user?.firstName ?? 'Sin nombre'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: const Text('Correo electrónico'),
                      subtitle: Text(user?.email ?? 'Sin correo'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.lock_outline),
                      title: const Text('Cambiar contraseña'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
