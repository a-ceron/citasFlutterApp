import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'create_procedure_dialog.dart';
import 'procedure_description_page.dart';

class ProceduresPage extends StatefulWidget {
  const ProceduresPage({super.key});

  @override
  State<ProceduresPage> createState() => _ProceduresPageState();
}

class _ProceduresPageState extends State<ProceduresPage> {
  final apiService = ApiService();
  List<Map<String, dynamic>> procedures = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProcedures();
  }

  Future<void> loadProcedures() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final data = await apiService.getProcedures(auth.accessToken ?? '');
      setState(() {
        procedures = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando procedimientos: $e')),
      );
    }
  }

  void _openCreateProcedureModal() {
    showDialog(
      context: context,
      builder: (_) => const CreateProcedureDialog(),
    ).then((_) => loadProcedures());
  }

  void _goToProcedureProfile(Map<String, dynamic> procedure) {
    if (procedure['id'] == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProcedureDescriptionPage(procedureId: procedure['id']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadProcedures,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isTablet ? _buildGrid() : _buildList(),
              ),
            ),
      floatingActionButton: !isTablet
          ? FloatingActionButton(
              onPressed: _openCreateProcedureModal,
              child: const Icon(Icons.add),
            )
          : null,
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
      itemCount: procedures.length + 1,
      itemBuilder: (context, index) {
        if (index < procedures.length) {
          return _procedureCard(procedures[index]);
        } else {
          return _procedureCard({}, isNew: true);
        }
      },
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: procedures.length,
      itemBuilder: (context, index) => _procedureCard(procedures[index]),
    );
  }

  Widget _procedureCard(Map<String, dynamic> procedure, {bool isNew = false}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isNew
            ? _openCreateProcedureModal
            : () => _goToProcedureProfile(procedure),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: isNew
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_box, size: 36, color: Colors.teal),
                    SizedBox(height: 8),
                    Text(
                      "Nuevo Procedimiento",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : Row(
                  children: [
                    const Icon(Icons.medical_services,
                        size: 32, color: Colors.teal),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        procedure['name'] ?? 'Procedimiento',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
        ),
      ),
    );
  }
}
