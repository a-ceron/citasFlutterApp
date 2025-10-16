import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A dedicated screen to display 404/routing errors.
class ErrorPage extends StatelessWidget {
  /// The GoRouter state containing details about the navigation error.
  final GoRouterState state;

  const ErrorPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    // Safely extract the error message from the GoRouterState
    final errorMessage =
        state.error?.toString() ?? 'The requested page could not be found.';
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FClinic'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Prominent 404 display
                  Text(
                    '404',
                    style: TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.error,
                      height: 1, // Keep typography compact
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Page Not Found',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Display the specific error detail
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Button to return to the root of the application
                  ElevatedButton.icon(
                    onPressed: () => context.go('/'),
                    icon: const Icon(Icons.home_filled),
                    label: const Text('Go to Home / Dashboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
