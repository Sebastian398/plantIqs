import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plantiq/generated/l10n.dart'; // Importar para localización

class Finca {
  final String nombre;
  final String direccion;
  final String presentacion;
  final String zonas;

  Finca({
    required this.nombre,
    required this.direccion,
    required this.presentacion,
    required this.zonas,
  });

  factory Finca.fromJson(Map<String, dynamic> json) {
    return Finca(
      nombre: json['nombre'] ?? '',
      direccion: json['direccion'] ?? '',
      presentacion: json['presentacion'] ?? '',
      zonas: json['zonas'] ?? '',
    );
  }
}

class User {
  final String firstName;
  final String lastName;
  final String telefono;
  final String email;

  User({
    required this.firstName,
    required this.lastName,
    required this.telefono,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      telefono: json['telefono'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class ApiService {
  static const String baseUrl = 'http://localhost:8000/';

  static Future<User> getCurrentUser([String? token]) async {
    final headers = <String, String>{"Content-Type": "application/json"};

    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/usuario-actual1/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar datos del usuario');
    }
  }

  static Future<Finca> getInfoFinca() async {
    final response = await http.get(Uri.parse('$baseUrl/api/infoFinca/'));

    if (response.statusCode == 200) {
      return Finca.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar datos de la finca');
    }
  }
}

class ProfileTab extends StatelessWidget {
  final String? token;
  const ProfileTab({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context); // Obtener localización sin !

    return FutureBuilder<User>(
      future: ApiService.getCurrentUser(token),
      builder: (context, userSnapshot) {
        Widget userInfoSection;
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          userInfoSection = const Center(child: CircularProgressIndicator());
        } else if (userSnapshot.hasError) {
          userInfoSection = Center(
            child: Text(loc.errorUsuario(userSnapshot.error.toString())),
          );
        } else if (!userSnapshot.hasData) {
          userInfoSection = Center(child: Text(loc.noUsuario));
        } else {
          User user = userSnapshot.data!;
          userInfoSection = Column(
            children: [
              CircleAvatar(
                radius: 110,
                backgroundColor: colors.surface,
                backgroundImage: const AssetImage('assets/icon/profile.png'),
              ),
              const SizedBox(height: 20),
              Text(
                loc.labelNombre,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                user.firstName,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Text(
                loc.labelApellido,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                user.lastName,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Text(
                loc.labelTelefono,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                user.telefono,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Text(
                loc.labelCorreo,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                user.email,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          );
        }

        return FutureBuilder<Finca>(
          future: ApiService.getInfoFinca(),
          builder: (context, fincaSnapshot) {
            if (fincaSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (fincaSnapshot.hasError) {
              return Center(
                child: Text(loc.errorFinca(fincaSnapshot.error.toString())),
              );
            } else if (!fincaSnapshot.hasData) {
              return Center(child: Text(loc.noFinca));
            } else {
              Finca finca = fincaSnapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Columna principal (izquierda) con datos de finca
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          // Información de la finca con datos dinámicos
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.only(bottom: 20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.maps_home_work_sharp,
                                      color: colors.onSurface,
                                      size: 50,
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      loc.labelNombreFinca,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      finca.nombre,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 30),
                                    Text(
                                      loc.labelDireccionFinca,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      finca.direccion,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 30),
                                    Text(
                                      loc.labelPresentacionFinca,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      finca.presentacion,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 30),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Sección de mapa (imagen estática)
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      loc.labelUbicacionFinca,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 15),
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: colors.surface,
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          child: Image.asset(
                                            'assets/icon/finca.png',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 220,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 60),

                    // Columna lateral derecha con datos dinámicos del usuario
                    Center(
                      child: Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(70),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: SingleChildScrollView(child: userInfoSection),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }
}
