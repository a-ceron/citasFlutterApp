import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';

class CreateRecordDialog extends StatefulWidget {
  const CreateRecordDialog({super.key});

  @override
  State<CreateRecordDialog> createState() => _CreateRecordDialogState();
}

class _CreateRecordDialogState extends State<CreateRecordDialog> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedClient;
  int? _selectedProcedure;
  int? _selectedEmployee;
  final _costController = TextEditingController();
  final _paymentController = TextEditingController();
  final _notesController = TextEditingController();
  bool _requiresInvoice = false;
  bool _isSaving = false;

  List<dynamic> _clients = [];
  List<dynamic> _procedures = [];
  List<dynamic> _employees = [];

  @override
  void initState() {
    super.initState();
    _loadDropdowns();
  }

  Future<void> _loadDropdowns() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final token = auth.accessToken ?? '';
    final api = ApiService();

    try {
      final clients = await api.getClients(token);
      final procedures = await api.getProcedures(token);
      final employees = await api.getEmployees(token);

      setState(() {
        _clients = clients;
        _procedures = procedures;
        _employees = employees;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error cargando datos: $e')));
    }
  }

  Future<void> _saveRecord() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClient == null ||
        _selectedProcedure == null ||
        _selectedEmployee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seleccione todos los campos')));
      return;
    }

    setState(() => _isSaving = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final token = auth.accessToken ?? '';
    final api = ApiService();

    final recordData = {
      "client_id": _selectedClient,
      "procedure_id": _selectedProcedure,
      "employee_id": _selectedEmployee,
      "cost": double.tryParse(_costController.text) ?? 0.0,
      "payment_method": _paymentController.text,
      "requires_invoice": _requiresInvoice,
      "notes": _notesController.text,
      "registered_by": auth.user?.firstName ?? "Admin",
    };

    try {
      await api.createRecord(token, recordData);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registro creado con éxito')));
      }
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error creando registro: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo Registro'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                initialValue: _selectedClient,
                items: _clients
                    .map((c) => DropdownMenuItem<int>(
                        value: c['id'],
                        child: Text(c['first_name'] + ' ' + c['last_name'])))
                    .toList(),
                onChanged: (val) => setState(() => _selectedClient = val),
                decoration: const InputDecoration(labelText: 'Paciente'),
                validator: (val) =>
                    val == null ? 'Seleccione un paciente' : null,
              ),
              DropdownButtonFormField<int>(
                initialValue: _selectedProcedure,
                items: _procedures
                    .map((p) => DropdownMenuItem<int>(
                        value: p['id'], child: Text(p['name'])))
                    .toList(),
                onChanged: (val) => setState(() => _selectedProcedure = val),
                decoration: const InputDecoration(labelText: 'Procedimiento'),
                validator: (val) =>
                    val == null ? 'Seleccione un procedimiento' : null,
              ),
              DropdownButtonFormField<int>(
                initialValue: _selectedEmployee,
                items: _employees
                    .map((e) => DropdownMenuItem<int>(
                        value: e['id'],
                        child: Text(e['first_name'] + ' ' + e['last_name'])))
                    .toList(),
                onChanged: (val) => setState(() => _selectedEmployee = val),
                decoration: const InputDecoration(labelText: 'Médico'),
                validator: (val) => val == null ? 'Seleccione un médico' : null,
              ),
              TextFormField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Costo'),
                validator: (val) => val == null || double.tryParse(val) == null
                    ? 'Ingrese un número válido'
                    : null,
              ),
              TextFormField(
                controller: _paymentController,
                decoration: const InputDecoration(labelText: 'Método de pago'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notas'),
                maxLines: 2,
              ),
              CheckboxListTile(
                value: _requiresInvoice,
                onChanged: (val) =>
                    setState(() => _requiresInvoice = val ?? false),
                title: const Text('Requiere factura'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveRecord,
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }
}
