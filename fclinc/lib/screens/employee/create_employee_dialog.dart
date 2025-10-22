import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';

class CreateEmployeeDialog extends StatefulWidget {
  const CreateEmployeeDialog({super.key});

  @override
  State<CreateEmployeeDialog> createState() => _CreateEmployeeDialogState();
}

class _CreateEmployeeDialogState extends State<CreateEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'is_active': true, // valor por defecto
  };
  bool _isLoading = false;
  final _dateController = TextEditingController();
  String? _selectedRole;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    _formData['role'] = _selectedRole;

    setState(() => _isLoading = true);

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final token = auth.accessToken ?? '';
      await ApiService().createEmployee(_formData, token);
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final dialogWidth = width >= 600 ? 500.0 : double.infinity;

    return AlertDialog(
      title: const Text('Crear Empleado'),
      content: SizedBox(
        width: dialogWidth,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  onSaved: (v) => _formData['first_name'] = v,
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Requerido'
                      : (v.length > 50 ? 'Máx 50 caracteres' : null),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Apellido'),
                  onSaved: (v) => _formData['last_name'] = v,
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Requerido'
                      : (v.length > 50 ? 'Máx 50 caracteres' : null),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  onSaved: (v) => _formData['email'] = v,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Requerido';
                    if (!v.contains('@') || v.length > 120) {
                      return 'Email inválido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  onSaved: (v) => _formData['phone'] = v,
                  validator: (v) {
                    final pattern = RegExp(r'^\+?\d{7,20}$');
                    if (v == null || v.isEmpty) return 'Requerido';
                    if (!pattern.hasMatch(v)) return 'Formato inválido';
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Rol'),
                  initialValue: _selectedRole,
                  items: const [
                    DropdownMenuItem(
                        value: 'encargado', child: Text('Encargado clinico')),
                    DropdownMenuItem(
                        value: 'graduado', child: Text('Residente')),
                    DropdownMenuItem(
                        value: 'practicante', child: Text('Pasante')),
                  ],
                  onChanged: (v) => setState(() => _selectedRole = v),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Requerido' : null,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Número de licencia'),
                  onSaved: (v) => _formData['license_number'] = v,
                  validator: (v) =>
                      (v != null && v.length > 50) ? 'Máx 50 caracteres' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Especialidad'),
                  onSaved: (v) => _formData['specialty'] = v,
                  validator: (v) => (v != null && v.length > 100)
                      ? 'Máx 100 caracteres'
                      : null,
                ),
                SwitchListTile(
                  title: const Text('Activo'),
                  value: _formData['is_active']!,
                  onChanged: (v) => setState(() => _formData['is_active'] = v),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar')),
        _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(onPressed: _submit, child: const Text('Crear')),
      ],
    );
  }
}
