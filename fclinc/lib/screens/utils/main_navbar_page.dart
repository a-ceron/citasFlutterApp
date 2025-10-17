import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../employee/employees_page.dart';
import '../clients/client_page.dart';
import '../procedures/procedure_page.dart';
import '../records/records_page.dart';
import '../dash/dash_page.dart';

class MainNavbarPage extends StatefulWidget {
  const MainNavbarPage({super.key});

  @override
  State<MainNavbarPage> createState() => _MainNavbarPageState();
}

class _MainNavbarPageState extends State<MainNavbarPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashPage(),
    RecordsPage(),
    EmployeesPage(),
    ClientsPage(),
    ProceduresPage(),
  ];

  final List<String> _titles = const [
    'Dash',
    'Registros',
    'Empleados',
    'Clientes',
    'Procedimientos',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    auth.logout();

    // Use GoRouter to navigate and remove all history
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWeb = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            color: theme.colorScheme.error,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Row(
        children: [
          if (isWeb)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              labelType: NavigationRailLabelType.selected,
              selectedIconTheme:
                  IconThemeData(color: theme.colorScheme.primary, size: 28),
              selectedLabelTextStyle:
                  TextStyle(color: theme.colorScheme.primary),
              unselectedIconTheme:
                  IconThemeData(color: theme.colorScheme.onSurface),
              unselectedLabelTextStyle:
                  TextStyle(color: theme.colorScheme.onSurface),
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.dashboard), label: Text('Dash')),
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Registros')),
                NavigationRailDestination(
                    icon: Icon(Icons.people), label: Text('Empleados')),
                NavigationRailDestination(
                    icon: Icon(Icons.person), label: Text('Clientes')),
                NavigationRailDestination(
                    icon: Icon(Icons.medical_services),
                    label: Text('Procedimientos')),
              ],
            ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isWeb
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor: theme.colorScheme.primary,
              selectedItemColor: theme.colorScheme.onPrimary,
              unselectedItemColor: theme.colorScheme.onPrimary.withOpacity(0.6),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard), label: 'Dash'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Registros'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.people), label: 'Empleados'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Clientes'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.medical_services),
                    label: 'Procedimientos'),
              ],
            ),
    );
  }
}
