import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
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
    final isWeb = width >= 800;

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadRecords,
              child: isWeb ? _buildGridWithAddButton() : _buildList(),
            ),
      floatingActionButton: isWeb
          ? null
          : FloatingActionButton(
              onPressed: _openCreateRecordModal,
              backgroundColor: Colors.teal,
              child: const Icon(Icons.add),
            ),
    );
  }

  Widget _buildGridWithAddButton() {
    final items = [
      ...records,
      {'isAddButton': true}
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item['isAddButton'] == true) {
          return _addRecordCard();
        }
        return _recordCard(item);
      },
    );
  }

  Widget _addRecordCard() {
    return InkWell(
      onTap: _openCreateRecordModal,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add_box, size: 36, color: Colors.teal),
              SizedBox(height: 8),
              Text(
                "Nuevo registro",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
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
