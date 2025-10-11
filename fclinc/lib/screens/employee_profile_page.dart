import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class EmployeeProfilePage extends StatefulWidget {
  final int employeeId;

  const EmployeeProfilePage({super.key, required this.employeeId});

  @override
  State<EmployeeProfilePage> createState() => _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends State<EmployeeProfilePage> {
  final apiService = ApiService();
  Map<String, dynamic>? employee;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmployee();
  }

  Future<void> _loadEmployee() async {
    try {
      // Obtener token desde AuthProvider
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final data = await apiService.getEmployeeById(
        widget.employeeId,
        auth.accessToken ?? '',
      );

      setState(() {
        employee = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando empleado: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (employee == null) {
      return const Scaffold(
        body: Center(child: Text("Empleado no encontrado")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${employee!['first_name']} ${employee!['last_name']}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Text(employee!['first_name'][0],
                      style: const TextStyle(fontSize: 32)),
                ),
                const SizedBox(height: 16),
                Text("${employee!['first_name']} ${employee!['last_name']}",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(employee!['role'] ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const Divider(height: 32),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(employee!['email'] ?? ''),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(employee!['phone'] ?? ''),
                ),
                if (employee!['license_number'] != null)
                  ListTile(
                    leading: const Icon(Icons.badge),
                    title: Text(employee!['license_number']),
                  ),
                if (employee!['specialty'] != null)
                  ListTile(
                    leading: const Icon(Icons.medical_services),
                    title: Text(employee!['specialty']),
                  ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title:
                      Text("Contratado el: ${employee!['hired_date'] ?? ''}"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
