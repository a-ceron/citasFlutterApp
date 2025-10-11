import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class ProcedureDescriptionPage extends StatefulWidget {
  final int procedureId;
  const ProcedureDescriptionPage({super.key, required this.procedureId});

  @override
  State<ProcedureDescriptionPage> createState() =>
      _ProcedureDescriptionPageState();
}

class _ProcedureDescriptionPageState extends State<ProcedureDescriptionPage> {
  final apiService = ApiService();
  Map<String, dynamic>? procedure;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProcedure();
  }

  Future<void> _loadProcedure() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final token = auth.accessToken ?? '';

      final data = await apiService.getProcedureById(token, widget.procedureId);

      setState(() {
        procedure = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando procedimiento: $e')),
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

    if (procedure == null) {
      return const Scaffold(
        body: Center(child: Text("Procedimiento no encontrado")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(procedure!['name'] ?? 'Procedimiento')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  procedure!['name'] ?? '',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (procedure!['description'] != null)
                  Text(
                    procedure!['description'],
                    style: const TextStyle(fontSize: 16),
                  ),
                const SizedBox(height: 16),
                if (procedure!['cost'] != null)
                  Text(
                    "Costo: \$${procedure!['cost']}",
                    style: const TextStyle(fontSize: 16),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
