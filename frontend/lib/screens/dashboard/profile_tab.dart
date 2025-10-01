import 'dart:convert';
import 'dart:io'; // Para File de imagen
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Para seleccionar imagen
import 'package:plantiq/generated/l10n.dart'; // Importar para localización
import 'package:http_parser/http_parser.dart';

class Cultivo {
  final int id;
  final String nombre;
  final String tipo;
  final int? numeroLotes;
  final int? numeroAspersores;

  Cultivo({
    required this.id,
    required this.nombre,
    required this.tipo,
    this.numeroLotes,
    this.numeroAspersores,
  });

  factory Cultivo.fromJson(Map<String, dynamic> json) {
    return Cultivo(
      id: json['id'] ?? 0,
      nombre: json['nombre_cultivo'] ?? '',
      tipo: json['tipo_cultivo'] ?? '',
      numeroLotes: json['numero_lotes'],
      numeroAspersores: json['numero_aspersores'],
    );
  }
}

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
  final String? avatar_url; // Nueva propiedad para URL de avatar (del backend)

  User({
    required this.firstName,
    required this.lastName,
    required this.telefono,
    required this.email,
    this.avatar_url,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print("DEBUG USER JSON RECIBIDO: $json");
    final avatarUrl = json['avatar_url'];
    print("DEBUG AVATAR_URL EXTRAÍDO: $avatarUrl");

    return User(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      telefono: json['telefono'] ?? '',
      email: json['email'] ?? '',
      avatar_url: avatarUrl, // SOLO usar avatar_url del backend
    );
  }
}

class ApiService {
  static const String baseUrl = 'https://plantiq-07xw.onrender.com';

  static Future<User> getCurrentUser([String? token]) async {
    final headers = <String, String>{"Content-Type": "application/json"};

    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/usuario-actual1/'),
      headers: headers,
    );

    print("DEBUG GET USER STATUS: ${response.statusCode}");
    print("DEBUG GET USER RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar datos del usuario');
    }
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

  static Future<Finca> getInfoFinca() async {
    final response = await http.get(Uri.parse('$baseUrl/api/infoFinca/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.isEmpty || (data['nombre']?.toString().isEmpty ?? true)) {
        throw Exception('NoFincaData');
      }
      return Finca.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('NoFincaData');
    } else {
      throw Exception('Error al cargar datos de la finca');
    }
  }

  static Future<void> createFinca({
    required String nombre,
    required String direccion,
    required String presentacion,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/infoFinca/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'direccion': direccion,
        'presentacion': presentacion,
        'zonas': '',
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al crear finca: ${response.body}');
    }
  }

  // MÉTODO CORREGIDO PARA AVATAR
  static Future<Map<String, dynamic>> updateAvatar(
    File imageFile, [
    String? token,
  ]) async {
    print("DEBUG INICIANDO SUBIDA DE AVATAR...");

    final headers = <String, String>{};
    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/update-avatar/'),
    );
    request.headers.addAll(headers);

    final mimeType = 'image/jpg';
    request.files.add(
      await http.MultipartFile.fromPath(
        'avatar', // CORREGIDO: usar 'avatar' no 'avatar_url'
        imageFile.path,
        contentType: MediaType.parse(mimeType),
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print("DEBUG UPLOAD STATUS: ${response.statusCode}");
    print("DEBUG UPLOAD RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final avatarUrl = data['avatar_url'];
      final oldUrl = data['old_url'];

      print("DEBUG NUEVA AVATAR_URL RECIBIDA: $avatarUrl");
      print("DEBUG URL ANTERIOR ELIMINADA: $oldUrl");

      return {
        'success': true,
        'avatar_url': avatarUrl ?? '',
        'message': data['message'] ?? 'Avatar actualizado',
        'old_url': oldUrl,
      };
    } else {
      throw Exception(
        'Error al subir avatar: ${response.statusCode} - ${response.body}',
      );
    }
  }
}

class ProfileTab extends StatefulWidget {
  final String? token;
  const ProfileTab({super.key, this.token});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  File? _selectedImage; // Preview temporal de imagen seleccionada
  String? _newAvatarUrl; // URL recién subida (más fresca que la del backend)
  final ImagePicker _picker = ImagePicker();
  late Future<Finca> _fincaFuture;
  late Future<List<Cultivo>>
  _cultivosFuture; // Variable de estado para cultivos
  final TextEditingController _nombreFincaController = TextEditingController();
  final TextEditingController _direccionFincaController =
      TextEditingController();
  final TextEditingController _presentacionFincaController =
      TextEditingController();

  // Key para forzar recarga del FutureBuilder del usuario
  Key _userFutureKey = UniqueKey();

  // MÉTODO CORREGIDO PARA SUBIR AVATAR
  Future<void> _pickAndUploadImage() async {
    print("DEBUG SELECCIONANDO IMAGEN...");

    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      print("DEBUG IMAGEN SELECCIONADA: ${pickedFile.path}");

      setState(() {
        _selectedImage = File(pickedFile.path); // Preview temporal
        _newAvatarUrl = null; // Limpiar URL anterior
      });

      try {
        // Subir al backend
        final result = await ApiService.updateAvatar(
          _selectedImage!,
          widget.token,
        );

        if (result['success'] == true) {
          final avatarUrl = result['avatar_url'] as String;
          final oldUrl = result['old_url'];

          print("DEBUG SUBIDA EXITOSA:");
          print("  - Nueva URL: $avatarUrl");
          print("  - URL anterior eliminada: $oldUrl");

          setState(() {
            _selectedImage = null; // Limpiar preview
            _newAvatarUrl = avatarUrl; // Guardar nueva URL única
            _userFutureKey = UniqueKey(); // Forzar recarga del usuario
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).msgFotoPerfilOk),
            ),
          );
        }
      } catch (e) {
        print("DEBUG ERROR EN SUBIDA: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al subir la foto: $e')));
        setState(() {
          _selectedImage = null;
          _newAvatarUrl = null;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fincaFuture = _loadFinca();
    _cultivosFuture = ApiService.getCultivos(); // Inicialización de cultivos
  }

  Future<Finca> _loadFinca() async {
    return await ApiService.getInfoFinca();
  }

  Future<void> _guardarFinca() async {
    final loc = AppLocalizations.of(context);

    String nombre = _nombreFincaController.text.trim();
    String direccion = _direccionFincaController.text.trim();
    String presentacion = _presentacionFincaController.text.trim();

    if (nombre.isEmpty || direccion.isEmpty || presentacion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc.msgCamposObligatorios ?? 'Todos los campos son obligatorios',
          ),
        ),
      );
      return;
    }

    try {
      await ApiService.createFinca(
        nombre: nombre,
        direccion: direccion,
        presentacion: presentacion,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).msgFincaGuardada)),
      );

      setState(() {
        _fincaFuture = _loadFinca();
      });

      _nombreFincaController.clear();
      _direccionFincaController.clear();
      _presentacionFincaController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    }
  }

  Widget _buildFincaFormContainer() {
    final colors = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.onSurface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.maps_home_work_sharp,
                    color: colors.onPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: Text(
                    loc.infoFinca,
                    style: TextStyle(
                      color: colors.tertiary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _nombreFincaController,
              style: TextStyle(
                color: colors.onSecondary,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              cursorColor: colors.onSecondary,
              decoration: InputDecoration(
                labelText: loc.labelNombreFinca,
                labelStyle: TextStyle(
                  color: colors.onSecondary,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.home,
                  color: colors.onSecondary,
                  size: 20,
                ),
                filled: true,
                fillColor: colors.tertiary,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colors.onPrimary),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colors.secondary, width: 1),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _direccionFincaController,
              style: TextStyle(
                color: colors.onSecondary,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              cursorColor: colors.onSecondary,
              decoration: InputDecoration(
                labelText: loc.labelDireccionFinca,
                labelStyle: TextStyle(
                  color: colors.onSecondary,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.location_on,
                  color: colors.onSecondary,
                  size: 20,
                ),
                filled: true,
                fillColor: colors.tertiary,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colors.onPrimary),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colors.secondary, width: 1),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _presentacionFincaController,
              style: TextStyle(
                color: colors.onSecondary,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              cursorColor: colors.onSecondary,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: loc.labelPresentacionFinca,
                labelStyle: TextStyle(
                  color: colors.onSecondary,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.info_outline,
                  color: colors.onSecondary,
                  size: 20,
                ),
                filled: true,
                fillColor: colors.tertiary,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colors.onPrimary),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colors.secondary, width: 1),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: _guardarFinca,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.onSurface,
                  foregroundColor: colors.onPrimary,
                  minimumSize: const Size(200, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: Text(
                  'Guardar',
                  style: TextStyle(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget principal contenedor de cultivos
  Widget _buildCultivosContainer() {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título con ícono
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.onSurface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.agriculture,
                  color: colors.onPrimary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Cultivos Registrados',
                style: TextStyle(
                  color: colors.tertiary, // VUELTO AL COLOR ORIGINAL DEL TEMA
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Lista de cultivos
          Expanded(
            child: FutureBuilder<List<Cultivo>>(
              future: _cultivosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error al cargar cultivos: ${snapshot.error}',
                      style: TextStyle(color: colors.onPrimary),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.eco_outlined,
                          size: 50,
                          color: colors.onPrimary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No hay cultivos registrados',
                          style: TextStyle(
                            color: colors.onPrimary.withOpacity(0.7),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // Mostrar lista de cultivos
                List<Cultivo> cultivos = snapshot.data!;
                return ListView.builder(
                  itemCount: cultivos.length,
                  itemBuilder: (context, index) {
                    Cultivo cultivo = cultivos[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: colors.tertiary,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nombre del cultivo
                          Row(
                            children: [
                              Icon(Icons.eco, color: colors.primary, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  cultivo.nombre,
                                  style: TextStyle(
                                    color: Colors.black, // CAMBIADO A NEGRO
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Tipo de cultivo
                          Text(
                            'Tipo: ${cultivo.tipo}',
                            style: TextStyle(
                              color: Colors.black, // CAMBIADO A NEGRO
                              fontSize: 14,
                            ),
                          ),

                          // Información adicional si está disponible
                          if (cultivo.numeroLotes != null)
                            Text(
                              'Lotes: ${cultivo.numeroLotes}',
                              style: TextStyle(
                                color: Colors.black, // CAMBIADO A NEGRO
                                fontSize: 14,
                              ),
                            ),

                          if (cultivo.numeroAspersores != null)
                            Text(
                              'Aspersores: ${cultivo.numeroAspersores}',
                              style: TextStyle(
                                color: Colors.black, // CAMBIADO A NEGRO
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nombreFincaController.dispose();
    _direccionFincaController.dispose();
    _presentacionFincaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    return FutureBuilder<User>(
      key: _userFutureKey,
      future: ApiService.getCurrentUser(widget.token),
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

          // LÓGICA DE AVATAR CORREGIDA CON PRIORIDADES Y ANTI-CACHE
          ImageProvider avatarImage;
          String debugInfo = "";

          if (_selectedImage != null) {
            // 1ra prioridad: Preview temporal
            avatarImage = FileImage(_selectedImage!);
            debugInfo = "Usando preview temporal";
          } else if (_newAvatarUrl != null && _newAvatarUrl!.isNotEmpty) {
            // 2da prioridad: URL recién subida (con timestamp único)
            // Agregar parámetro anti-cache
            final urlWithTimestamp =
                "$_newAvatarUrl?t=${DateTime.now().millisecondsSinceEpoch}";
            avatarImage = NetworkImage(urlWithTimestamp);
            debugInfo = "Usando URL recién subida: $_newAvatarUrl";
          } else if (user.avatar_url != null && user.avatar_url!.isNotEmpty) {
            // 3ra prioridad: URL del backend (también con anti-cache)
            final urlWithTimestamp =
                "${user.avatar_url}?t=${DateTime.now().millisecondsSinceEpoch}";
            avatarImage = NetworkImage(urlWithTimestamp);
            debugInfo = "Usando URL del backend: ${user.avatar_url}";
          } else {
            // 4ta prioridad: Imagen por defecto
            avatarImage = const AssetImage('assets/icon/profile.png');
            debugInfo = "Usando imagen por defecto";
          }

          print("DEBUG AVATAR: $debugInfo");

          userInfoSection = Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 110,
                    backgroundColor: colors.surface,
                    backgroundImage: avatarImage,
                    onBackgroundImageError: (exception, stackTrace) {
                      print("DEBUG ERROR CARGANDO IMAGEN: $exception");
                      print("DEBUG STACK TRACE: $stackTrace");
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: _pickAndUploadImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.edit,
                          color: colors.onPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                loc.labelNombre,
                style: TextStyle(
                  color: colors.tertiary,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Text(
                user.firstName,
                style: TextStyle(color: colors.onPrimary, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Text(
                loc.labelApellido,
                style: TextStyle(
                  color: colors.tertiary,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Text(
                user.lastName,
                style: TextStyle(color: colors.onPrimary, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Text(
                loc.labelTelefono,
                style: TextStyle(
                  color: colors.tertiary,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Text(
                user.telefono,
                style: TextStyle(color: colors.onPrimary, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Text(
                loc.labelCorreo,
                style: TextStyle(
                  color: colors.tertiary,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Text(
                user.email,
                style: TextStyle(color: colors.onPrimary, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }

        return FutureBuilder<Finca>(
          future: _fincaFuture,
          builder: (context, fincaSnapshot) {
            if (fincaSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (fincaSnapshot.hasError) {
              if (fincaSnapshot.error.toString().contains('NoFincaData')) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildFincaFormContainer(),
                            ),
                            // PRIMERA LLAMADA - Estado sin datos de finca
                            Expanded(flex: 1, child: _buildCultivosContainer()),
                          ],
                        ),
                      ),
                      const SizedBox(width: 60),
                      Center(
                        child: Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(70),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(
                                context,
                              ).copyWith(scrollbars: false),
                              child: SingleChildScrollView(
                                child: userInfoSection,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text(loc.errorFinca(fincaSnapshot.error.toString())),
                );
              }
            } else if (!fincaSnapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(flex: 1, child: _buildFincaFormContainer()),
                          // SEGUNDA LLAMADA - Fallback sin datos
                          Expanded(flex: 1, child: _buildCultivosContainer()),
                        ],
                      ),
                    ),
                    const SizedBox(width: 60),
                    Center(
                      child: Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(70),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(
                              context,
                            ).copyWith(scrollbars: false),
                            child: SingleChildScrollView(
                              child: userInfoSection,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              );
            } else {
              Finca finca = fincaSnapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(25),
                              margin: const EdgeInsets.only(bottom: 20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: colors.onSurface,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.2,
                                                ),
                                                blurRadius: 6,
                                                offset: const Offset(2, 4),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.maps_home_work_sharp,
                                            color: colors.onPrimary,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Flexible(
                                          child: Text(
                                            loc.infoFinca,
                                            style: TextStyle(
                                              color: colors.tertiary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      loc.labelNombreFinca,
                                      style: TextStyle(
                                        color: colors.tertiary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      finca.nombre,
                                      style: TextStyle(
                                        color: colors.onPrimary,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      loc.labelDireccionFinca,
                                      style: TextStyle(
                                        color: colors.tertiary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      finca.direccion,
                                      style: TextStyle(
                                        color: colors.onPrimary,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      loc.labelPresentacionFinca,
                                      style: TextStyle(
                                        color: colors.tertiary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      finca.presentacion,
                                      style: TextStyle(
                                        color: colors.onPrimary,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // TERCERA LLAMADA - Con datos de finca
                          Expanded(flex: 1, child: _buildCultivosContainer()),
                        ],
                      ),
                    ),
                    const SizedBox(width: 60),
                    Center(
                      child: Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(70),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(
                              context,
                            ).copyWith(scrollbars: false),
                            child: SingleChildScrollView(
                              child: userInfoSection,
                            ),
                          ),
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
