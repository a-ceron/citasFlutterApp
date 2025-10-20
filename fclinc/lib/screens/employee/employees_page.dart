import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../login/login_page.dart';
import 'create_employee_dialog.dart';
import 'employee_profile_page.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  final apiService = ApiService();
  List<Map<String, dynamic>> employees = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final data = await apiService.getEmployees(auth.accessToken ?? '');
      setState(() {
        employees = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando empleados: $e')),
      );
    }
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

  void _openCreateEmployeeModal() {
    showDialog(
      context: context,
      builder: (_) => const CreateEmployeeDialog(),
    ).then((_) => loadEmployees());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadEmployees,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isTablet ? _buildGrid() : _buildList(),
              ),
            ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: employees.length + 1,
      itemBuilder: (context, index) {
        if (index < employees.length) {
          return _employeeCard(employees[index]);
        } else {
          return _employeeCard({}, isNew: true);
        }
      },
    );
  }

  Widget _buildList() {
    return Stack(
      children: [
        ListView.builder(
          itemCount: employees.length,
          itemBuilder: (context, index) => _employeeCard(employees[index]),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _openCreateEmployeeModal,
            backgroundColor: Colors.teal,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _employeeCard(Map<String, dynamic> emp, {bool isNew = false}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap:
            isNew ? _openCreateEmployeeModal : () => _goToEmployeeProfile(emp),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: isNew
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_box, size: 36, color: Colors.teal),
                    SizedBox(height: 8),
                    Text(
                      "Nuevo Empleado",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.teal.shade100,
                      child: Text(
                        emp['first_name']?[0]?.toUpperCase() ?? '?',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${emp['first_name']} ${emp['last_name']}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            emp['role'] ?? '',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
        ),
      ),
    );
  }

  void _goToEmployeeProfile(Map<String, dynamic> emp) {
    if (emp['id'] == null) return; // seguridad
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmployeeProfilePage(employeeId: emp['id']),
      ),
    );
  }
}
