import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantiq/models/cultivo.dart';
import '../constants.dart';
import '../models/programacion_riego.dart';
import '../models/Riego.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<http.Response> registerUser(
    String firstName,
    String lastName,
    String email,
    String password,
    String password2,
  ) {
    return http.post(
      Uri.parse(registerEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "password2": password2,
      }),
    );
  }

  static Future<http.Response> loginUser(String email, String password) {
    return http.post(
      Uri.parse(loginEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
  }

  static Future<List<Cultivo>> getCultivos() async {
    final response = await http.get(Uri.parse('$baseUrl/api/cultivos/'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Cultivo.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar cultivos');
    }
  }

  static Future<List<Cultivo1>> getCultivos1() async {
    final response = await http.get(Uri.parse('$baseUrl/api/cultivos/'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Cultivo1.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar cultivos');
    }
  }

  static Future<Cultivo> crearCultivo({
    required String nombre,
    required String tipo,
    required int? numero_lotes,
    required int? numero_aspersores,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/cultivos/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nombre_cultivo": nombre,
        "tipo_cultivo": tipo,
        "numero_lotes": numero_lotes,
        "numero_aspersores": numero_aspersores,
      }),
    );

    if (response.statusCode == 201) {
      return Cultivo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error al crear cultivo: ${response.body}");
    }
  }

  static Future<void> editarProgramacionRiego(
    ProgramacionRiego programacion,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/programacion_riego_admin/${programacion.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(programacion.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al editar riego');
    }
  }

  static Future<bool> eliminarRiego(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/programacion_riego_admin/$id/'),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 204;
  }

  static Future<bool> createRiego(
    int cultivo,
    String inicio,
    int duracion,
  ) async {
    final response = await http.post(
      Uri.parse(riegosEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "cultivo": cultivo,
        "inicio": inicio,
        "duracion": duracion,
        "activo": true,
      }),
    );

    return response.statusCode == 201;
  }

  static Future<List<LecturaSensor>> getLecturasSensores({
    int? cultivoId,
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token no encontrado, requiere login');
    }

    // Armar URL con parámetro cultivo si está definido
    String url = '$baseUrl/api/lecturas_humedad/';
    if (cultivoId != null) {
      url += '?cultivo=$cultivoId';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => LecturaSensor.fromJson(json)).toList();
    } else {
      throw Exception(
        'Error al cargar lecturas de sensores: ${response.statusCode}',
      );
    }
  }

  // NUEVO MÉTODO: Eliminar un cultivo por ID
  static Future<bool> eliminarCultivo(int id) async {
    final response = await http.delete(
      Uri.parse(
        '$baseUrl/api/cultivos/$id/',
      ), // Asumiendo endpoint DELETE /api/cultivos/{id}/
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 204 || response.statusCode == 200) {
      return true; // Éxito
    } else {
      throw Exception(
        'Error al eliminar cultivo: ${response.statusCode} - ${response.body}',
      );
    }
  }

  static Future<bool> getEstadoBomba() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/bomba/'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['is_on'] ?? false;
    } else {
      throw Exception('Error al obtener estado bomba: ${response.statusCode}');
    }
  }

  // POST activar bomba
  static Future<void> activarBomba(bool newState) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/bomba/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'is_on': newState}),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al activar bomba: ${response.statusCode}');
    }
  }
}
