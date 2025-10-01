import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ApiService {
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

  static Future<http.Response> createCultivo(
    String token,
    String nombreCultivo,
    String tipoCultivo,
    int numeroLotes,
    int numeroAspersores,
    String inicioRiego, // formato "HH:mm"
    int duracionRiego,
  ) {
    return http.post(
      Uri.parse(cultivosEndpoint),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "nombre_cultivo": nombreCultivo,
        "tipo_cultivo": tipoCultivo,
        "numero_lotes": numeroLotes,
        "nuermo_aspersores": numeroAspersores,
        "inicio_riego": inicioRiego,
        "duracion_riego": duracionRiego,
      }),
    );
  }

  static Future<bool> changePassword(
    String oldPassword,
    String newPassword,
    String token,
  ) async {
    final url = Uri.parse(
      'https://plantiq-07xw.onrender.com/api/password_reset/',
    );
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token", // Si usas token de autenticación
      },
      body: jsonEncode({
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      // Opcional: manejar errores específicos con response.body
      return false;
    }
  }

  static Future<bool> createRiego(
    String token,
    int cultivoId,
    String inicio,
    int duracion,
  ) async {
    final response = await http.post(
      Uri.parse(riegosEndpoint), // define esta constante en constants.dart
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "cultivo_id": cultivoId,
        "fecha_inicio": inicio,
        "duracion_minutos": duracion,
      }),
    );

    return response.statusCode == 201;
  }
}
