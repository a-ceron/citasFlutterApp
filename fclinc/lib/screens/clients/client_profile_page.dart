import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';

class ClientProfilePage extends StatefulWidget {
  final int clientId;

  const ClientProfilePage({super.key, required this.clientId});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  final apiService = ApiService();
  Map<String, dynamic>? client;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClient();
  }

  Future<void> _loadClient() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final token = auth.accessToken ?? '';

      final data = await apiService.getClientById(token, widget.clientId);

      setState(() {
        client = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando cliente: $e')),
      );
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Desconocido';
    try {
      final date = DateTime.parse(dateStr);
      return "${date.day}/${date.month}/${date.year}";
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (client == null) {
      return const Scaffold(
        body: Center(child: Text("Cliente no encontrado")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${client!['first_name'] ?? ''} ${client!['last_name'] ?? ''}"),
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
                  backgroundColor: Colors.teal.shade100,
                  child: Text(
                    (client!['first_name'] != null &&
                            client!['first_name'].isNotEmpty)
                        ? client!['first_name'][0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 32, color: Colors.teal),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "${client!['first_name'] ?? ''} ${client!['last_name'] ?? ''}",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Divider(height: 32),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(client!['email'] ?? 'Sin correo'),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(client!['phone'] ?? 'Sin teléfono'),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: Text(client!['address'] ?? 'Sin dirección'),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text("Creado: ${_formatDate(client!['createdAt'])}"),
                ),
                ListTile(
                  leading: const Icon(Icons.update),
                  title: Text(
                      "Última actualización: ${_formatDate(client!['updatedAt'])}"),
                ),
                if (client!['notes'] != null &&
                    client!['notes'].toString().isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.note),
                    title: Text(client!['notes']),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
