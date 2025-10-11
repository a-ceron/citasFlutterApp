import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'create_recor_page.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  final apiService = ApiService();
  List<Map<String, dynamic>> records = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRecords();
  }

  Future<void> loadRecords() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final data = await apiService.getRecords(auth.accessToken ?? '');
      setState(() {
        records = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando registros: $e')),
      );
    }
  }

  void _openCreateRecordModal() {
    showDialog(
      context: context,
      builder: (_) => const CreateRecordDialog(),
    ).then((_) => loadRecords());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadRecords,
              child: isTablet ? _buildGrid() : _buildList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateRecordModal,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: records.length,
      itemBuilder: (context, index) {
        return _recordCard(records[index]);
      },
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: records.length,
      itemBuilder: (context, index) => _recordCard(records[index]),
    );
  }

  Widget _recordCard(Map<String, dynamic> record) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Paciente: ${record['client_name'] ?? record['client_id']}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Procedimiento: ${record['procedure_name'] ?? record['procedure_id']}",
            ),
            const SizedBox(height: 4),
            Text("Médico: ${record['employee_name'] ?? record['employee_id']}"),
            const SizedBox(height: 4),
            Text("Costo: \$${record['cost']}"),
            const SizedBox(height: 2),
            Text("Fecha: ${record['timestamp']}"),
          ],
        ),
      ),
    );
  }
}
