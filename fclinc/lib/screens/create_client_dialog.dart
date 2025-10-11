import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';

class CreateClientDialog extends StatefulWidget {
  const CreateClientDialog({super.key});

  @override
  State<CreateClientDialog> createState() => _CreateClientDialogState();
}

class _CreateClientDialogState extends State<CreateClientDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool isSaving = false;

  Future<void> _saveClient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);
    final apiService = ApiService();
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final clientData = {
      "first_name": _firstNameController.text.trim(),
      "last_name": _lastNameController.text.trim(),
      "email": _emailController.text.trim(),
      "phone": _phoneController.text.trim(),
      "address": _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
    };

    try {
      await apiService.createClient(auth.accessToken ?? '', clientData);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cliente creado con éxito")),
        );
      }
    } catch (e) {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear cliente: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nuevo Cliente"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: "Apellido"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Correo"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value != null && value.contains('@')
                    ? null
                    : "Correo inválido",
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Teléfono"),
                keyboardType: TextInputType.phone,
                validator: (value) => value != null && value.length >= 7
                    ? null
                    : "Teléfono inválido",
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Dirección"),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: isSaving ? null : _saveClient,
          child: isSaving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Crear"),
        ),
      ],
    );
  }
}
