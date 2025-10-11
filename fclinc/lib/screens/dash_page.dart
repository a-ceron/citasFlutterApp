import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class DashPage extends StatefulWidget {
  const DashPage({super.key});

  @override
  State<DashPage> createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  final apiService = ApiService();
  Map<String, dynamic>? dashData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDash();
  }

  Future<void> loadDash() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final data = await apiService.getDash(auth.accessToken ?? '');
      setState(() {
        dashData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando dashboard: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadDash,
              child: isTablet ? _buildGrid() : _buildList(),
            ),
    );
  }

  Widget _buildGrid() {
    final kpis = dashData!['kpis'] ?? {};
    final empleados =
        List<Map<String, dynamic>>.from(dashData!['empleados'] ?? []);

    return GridView.count(
      padding: const EdgeInsets.all(8),
      crossAxisCount: 2,
      childAspectRatio: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: [
        _kpiCard('Total Citas', kpis['total_citas']?.toString() ?? '0'),
        _kpiCard('Total Generado', kpis['total_generado']?.toString() ?? '0'),
        _kpiCard(
            'Promedio', kpis['promedio_por_cita']?.toStringAsFixed(2) ?? '0'),
        ...empleados.map((e) => _employeeCard(e)).toList(),
      ],
    );
  }

  Widget _buildList() {
    final kpis = dashData!['kpis'] ?? {};
    final empleados =
        List<Map<String, dynamic>>.from(dashData!['empleados'] ?? []);

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        _kpiCard('Total Citas', kpis['total_citas']?.toString() ?? '0'),
        _kpiCard('Total Generado', kpis['total_generado']?.toString() ?? '0'),
        _kpiCard(
            'Promedio', kpis['promedio_por_cita']?.toStringAsFixed(2) ?? '0'),
        const SizedBox(height: 16),
        ...empleados.map((e) => _employeeCard(e)).toList(),
      ],
    );
  }

  Widget _kpiCard(String title, String value) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(value,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _employeeCard(Map<String, dynamic> emp) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        title: Text(emp['name'] ?? ''),
        subtitle: Text(
            'Citas: ${emp['total_citas'] ?? 0} - Generado: ${emp['total_generado'] ?? 0}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
