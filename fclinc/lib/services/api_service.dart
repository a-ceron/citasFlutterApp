import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://127.0.0.1:5000';
  // -----------------------------
  // Agrega este método:
  // -----------------------------
  /// Obtener el reporte dinámico (dash)
  Future<Map<String, dynamic>> getDash(String token,
      {String? startDate, String? endDate}) async {
    final uri = Uri.parse('$baseUrl/web/app/report').replace(
      queryParameters: {
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception(
          'Error al obtener dash report: ${response.statusCode} ${response.body}');
    }
  }

  Future<bool> postGoogleToken(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error en login Google: ${response.body}');
    }

    final data = jsonDecode(response.body);
    return true;
  }

  /// Nuevo método: login con Google OAuth
  Future<String?> loginWithGoogle(String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'code': code}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error en login Google: ${response.body}');
    }

    final data = jsonDecode(response.body);
    return data['access_token'];
  }

  Future<void> createRecord(String token, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/records'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear registro: ${response.body}');
    }
  }

  // -----------------------------
// Get records
// -----------------------------
  Future<List<Map<String, dynamic>>> getRecords(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/records'),
      headers: {'Authorization': 'Bearer $token', 'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['items'] ?? []);
    } else {
      throw Exception('Error fetching records');
    }
  }

  /// Obtener todos los procedimientos
  Future<List<Map<String, dynamic>>> getProcedures(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/procedures'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['items'] ?? []);
    } else {
      throw Exception('Error al obtener procedimientos');
    }
  }

  /// Obtener un procedimiento por ID
  Future<Map<String, dynamic>> getProcedureById(String token, int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/procedures/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Procedimiento no encontrado');
    } else {
      throw Exception('Error al obtener procedimiento: ${response.body}');
    }
  }

  /// Crear un nuevo procedimiento
  Future<Map<String, dynamic>> createProcedure(
      String token, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/procedures'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception(
          'Error al crear procedimiento: ${response.statusCode} ${response.body}');
    }
  }

  Future<List<dynamic>> getClients(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/clients'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['items'] ?? []; // <-- aquí extraemos solo items
    } else {
      throw Exception('Error fetching clients');
    }
  }

  Future<Map<String, dynamic>> getClientById(String token, int id) async {
    final url = Uri.parse('$baseUrl/clients/$id');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Cliente no encontrado');
    } else {
      throw Exception('Error al obtener cliente: ${response.body}');
    }
  }

  Future<void> createClient(String token, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/clients');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear cliente: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getEmployeeById(int id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/employees/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception('Empleado no encontrado');
    }
  }

  Future<String> login(String email, String password) async {
    print("Iniciando sesiòn");
    print(Uri.parse('$baseUrl/auth/login'));

    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    print("iniciando sesiòn");
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Error al iniciar sesión');
    }
  }

  // Obtener info básica del usuario logeado
  Future<Map<String, dynamic>> getMe(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/web/app/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('No se pudo obtener la info del usuario');
    }
  }

  Future<List<Map<String, dynamic>>> getEmployees(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/employees'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['items']);
    } else {
      throw Exception('Error al obtener empleados');
    }
  }

  /// Crear un nuevo empleado
  Future<Map<String, dynamic>> createEmployee(
      Map<String, dynamic> employeeData, String token) async {
    print(employeeData);
    final url = Uri.parse('$baseUrl/employees');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(employeeData),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Error al crear empleado: ${response.statusCode} ${response.body}');
    }
  }
}
