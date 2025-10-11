import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'create_client_dialog.dart';
import 'client_profile_page.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final apiService = ApiService();
  List<Map<String, dynamic>> clients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadClients();
  }

  Future<void> loadClients() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final data = await apiService.getClients(auth.accessToken ?? '');
      setState(() {
        clients = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando clientes: $e')),
      );
    }
  }

  void _openCreateClientModal() {
    showDialog(
      context: context,
      builder: (_) => const CreateClientDialog(),
    ).then((_) => loadClients());
  }

  void _goToClientProfile(Map<String, dynamic> client) {
    if (client['id'] == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClientProfilePage(clientId: client['id']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isTablet ? _buildGrid() : _buildList(),
      ),
      floatingActionButton: !isTablet
          ? FloatingActionButton(
              onPressed: _openCreateClientModal,
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
      itemCount: clients.length + 1,
      itemBuilder: (context, index) {
        if (index < clients.length) {
          return _clientCard(clients[index]);
        } else {
          return _clientCard({}, isNew: true);
        }
      },
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context, index) => _clientCard(clients[index]),
    );
  }

  Widget _clientCard(Map<String, dynamic> client, {bool isNew = false}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap:
            isNew ? _openCreateClientModal : () => _goToClientProfile(client),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: isNew
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_box, size: 32, color: Colors.teal),
                    SizedBox(height: 8),
                    Text(
                      "Nuevo Cliente",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : Row(
                  children: [
                    const Icon(Icons.person, size: 32, color: Colors.teal),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${client['first_name']} ${client['last_name']}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(client['email'] ?? '',
                              style: const TextStyle(fontSize: 14)),
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
}
