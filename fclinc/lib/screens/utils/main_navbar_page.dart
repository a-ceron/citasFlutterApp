import 'package:fclinc/screens/calendar/calendar_page.dart';
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

  final List<String> _titles = const [
    'Dash',
    'Registros',
    'Empleados',
    'Clientes',
    'Procedimientos',
    'Calendario'
  ];
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const DashPage(),
      const RecordsPage(),
      const EmployeesPage(),
      const ClientsPage(),
      const ProceduresPage(),
      const CalendarPage(), // You can keep it const for now if you fetch events inside CalendarPage via Provider
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    auth.logout();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWeb = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          PopupMenuButton<int>(
            icon: CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            onSelected: (value) {
              if (value == 0) {
                // Ir a perfil
                context
                    .go('/profile'); // Asegúrate de tener esta ruta en GoRouter
              } else if (value == 1) {
                // Cerrar sesión
                final auth = Provider.of<AuthProvider>(context, listen: false);
                auth.logout();
                context.go('/login');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('Perfil'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Cerrar sesión'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Row(
        children: [
          if (isWeb)
            Container(
              width: 200,
              color: theme.colorScheme.surface,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  for (int i = 0; i < _titles.length; i++)
                    InkWell(
                      onTap: () => _onItemTapped(i),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedIndex == i
                              ? theme.colorScheme.primary.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Icon(
                              [
                                Icons.dashboard,
                                Icons.home,
                                Icons.people,
                                Icons.person,
                                Icons.medical_services,
                                Icons.calendar_month
                              ][i],
                              color: _selectedIndex == i
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _titles[i],
                              style: TextStyle(
                                fontWeight: _selectedIndex == i
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _selectedIndex == i
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  const Spacer(),
                ],
              ),
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
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month), label: 'Citas'),
              ],
            ),
    );
  }
}
