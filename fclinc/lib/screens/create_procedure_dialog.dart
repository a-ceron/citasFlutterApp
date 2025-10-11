import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class CreateProcedureDialog extends StatefulWidget {
  const CreateProcedureDialog({super.key});

  @override
  State<CreateProcedureDialog> createState() => _CreateProcedureDialogState();
}

class _CreateProcedureDialogState extends State<CreateProcedureDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  final _durationController = TextEditingController();

  bool isSaving = false;

  Future<void> _saveProcedure() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);
    final apiService = ApiService();
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final procedureData = {
      "name": _nameController.text,
      "description": _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      "suggested_cost": double.tryParse(_costController.text) ?? 0.0,
      "duration_minutes": int.tryParse(_durationController.text) ?? 1,
    };

    try {
      await apiService.createProcedure(auth.accessToken ?? '', procedureData);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Procedimiento creado con éxito")),
        );
      }
    } catch (e) {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear procedimiento: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Descripción"),
                maxLines: 2,
              ),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(labelText: "Costo sugerido"),
                keyboardType: TextInputType.number,
                validator: (value) => (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null)
                    ? "Ingrese un número válido"
                    : null,
              ),
              TextFormField(
                controller: _durationController,
                decoration:
                    const InputDecoration(labelText: "Duración (minutos)"),
                keyboardType: TextInputType.number,
                validator: (value) => (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null ||
                        int.tryParse(value)! < 1)
                    ? "Ingrese un número válido mayor que 0"
                    : null,
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
          onPressed: isSaving ? null : _saveProcedure,
          child: isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Guardar"),
        ),
      ],
    );
  }
}
