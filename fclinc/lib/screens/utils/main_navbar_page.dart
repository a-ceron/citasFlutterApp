import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../employee/employees_page.dart';
import '../clients/client_page.dart';
import '../login/login_page.dart';
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
    ProceduresPage()
  ];

  final List<String> _titles = const [
    'Dash',
    'Inicio',
    'Empleados',
    'Clientes',
    'Procedimientos'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    auth.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            color: Colors.red, // color rojo para logout
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.teal,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.teal.shade100,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dash'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Empleados'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Clientes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.medical_services), label: 'Procedimientos'),
        ],
      ),
    );
  }
}
