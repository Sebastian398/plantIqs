import 'dart:convert'; // Para codificación/decodificación JSON
import 'package:flutter/material.dart'; // Widgets de Flutter
import 'package:provider/provider.dart'; // Para manejar estados globales
import 'package:http/http.dart' as http; // Para hacer llamadas HTTP
import 'package:plantiq/screens/auth/mail_reset.dart'; // Pantalla de reset de contraseña
import 'package:plantiq/widgets/theme_provider.dart'; // Proveedor de temas (claro/oscuro)
import 'package:plantiq/main.dart'; // Para acceder a LocaleProvider
import 'package:plantiq/generated/l10n.dart'; // Para localización (multilenguaje)
import 'package:plantiq/screens/auth/login_screen.dart'; // Pantalla de login

/// Función para obtener el token almacenado del usuario
/// Aquí normalmente usarías SharedPreferences o flutter_secure_storage
Future<String?> getStoredToken() async {
  return 'tu_token_de_ejemplo';
}

/// Función para limpiar el token almacenado (logout local)
Future<void> clearStoredToken() async {}

/// Widget principal de la pestaña de Configuración
class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

/// Estado de SettingsTab
class _SettingsTabState extends State<SettingsTab> {
  bool modoClaro = false; // Variable para manejar modo claro/oscuro

  /// Función para cerrar sesión del usuario
  Future<void> logout() async {
    final token = await getStoredToken(); // Obtener token
    if (token == null) return; // Si no hay token, salir

    // Llamada HTTP para cerrar sesión en el backend
    final response = await http.post(
      Uri.parse(
        'https://plantiq-07xw.onrender.com/api/logout/',
      ), // URL de logout
      headers: {
        'Authorization': 'Token $token', // Autenticación con token
        'Content-Type': 'application/json',
      },
    );

    final localizations = AppLocalizations.of(context);

    if (response.statusCode == 200) {
      // Logout exitoso: limpiar token y navegar a login
      await clearStoredToken();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } else {
      // Si hubo error, mostrar mensaje
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.settings_logout_error)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Acceder a proveedores y colores del tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: true);
    final colors = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.secondary, // Color de fondo de la pantalla
      body: Center(
        child: Container(
          width: 900,
          margin: const EdgeInsets.all(16), // Espacio alrededor del contenedor
          padding: const EdgeInsets.all(16), // Espacio interno
          decoration: BoxDecoration(
            color: colors.primary, // Color de fondo del contenedor
            borderRadius: BorderRadius.circular(16), // Bordes redondeados
            boxShadow: [
              BoxShadow(
                color: Colors.black, // sombra suave
                blurRadius: 10, // qué tan difusa
                spreadRadius: 2, // expansión
                offset: const Offset(0, 5), // desplazamiento (x,y)
              ),
            ],
          ),
          child: ListView(
            shrinkWrap: true, // Ajusta altura al contenido
            children: [
              // Título de la sección
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  localizations.settings_title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.onPrimary,
                  ),
                ),
              ),

              // Selector de idioma
              ListTile(
                leading: Icon(Icons.language, color: colors.onPrimary),
                title: Text(
                  AppLocalizations.of(context).settings_language,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: colors.onPrimary,
                  ),
                ),
                trailing: Switch(
                  value: localeProvider.locale.languageCode == 'en',
                  onChanged: (bool value) {
                    final newLocale = value
                        ? const Locale('en')
                        : const Locale('es');
                    localeProvider.setLocale(newLocale);
                  },
                  activeThumbColor:
                      Colors.white, // color del círculo cuando está activo
                  activeTrackColor:
                      Colors.green.shade400, // barra cuando activo
                  inactiveThumbColor:
                      Colors.grey.shade300, // círculo cuando inactivo
                  inactiveTrackColor:
                      Colors.grey.shade600, // barra cuando inactivo
                ),
              ),
              Divider(color: colors.tertiary),

              // Switch para modo claro/oscuro
              ListTile(
                leading: Icon(Icons.light_mode, color: colors.onPrimary),
                title: Text(
                  localizations.settings_light_mode,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: colors.onPrimary,
                  ),
                ),
                trailing: Switch(
                  value: themeProvider.themeMode == ThemeMode.light,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  activeThumbColor:
                      Colors.white, // color del círculo cuando está activo
                  activeTrackColor:
                      Colors.green.shade400, // barra cuando activo
                  inactiveThumbColor:
                      Colors.grey.shade300, // círculo cuando inactivo
                  inactiveTrackColor:
                      Colors.grey.shade600, // barra cuando inactivo
                ),
              ),
              Divider(color: colors.tertiary),

              // Acceso a datos del usuario
              ListTile(
                leading: Icon(Icons.person, color: colors.onPrimary),
                title: Text(
                  localizations.settings_user_data,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: colors.onPrimary,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditarDatosUsuario(),
                    ),
                  );
                },
              ),
              Divider(color: colors.tertiary),

              // Acceso a datos de la finca
              ListTile(
                leading: Icon(Icons.agriculture, color: colors.onPrimary),
                title: Text(
                  localizations.settings_farm_data,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: colors.onPrimary,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditarDatosFinca(),
                    ),
                  );
                },
              ),
              Divider(color: colors.tertiary),

              // Opciones de autenticación
              ListTile(
                leading: Icon(Icons.lock, color: colors.onPrimary),
                title: Text(
                  localizations.settings_auth,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: colors.onPrimary,
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: colors.secondary,
                      title: Text(
                        localizations.settings_auth_options,
                        style: TextStyle(color: colors.onPrimary),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                colors.tertiary,
                              ),
                              fixedSize: WidgetStateProperty.all(
                                const Size(200, 30),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MailResetScreen(),
                                ),
                              );
                            },
                            child: Text(
                              localizations.settings_change_password,
                              style: TextStyle(color: colors.onPrimary),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Colors.redAccent,
                              ),
                              fixedSize: WidgetStateProperty.all(
                                const Size(200, 30),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PaginaInicio(),
                                ),
                              );
                            },
                            child: Text(
                              localizations.settings_logout,
                              style: TextStyle(color: colors.onPrimary),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            localizations.settings_cancel,
                            style: TextStyle(color: colors.primary),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// -------------------------------------------------------------
/// Clase para editar los datos del usuario
/// -------------------------------------------------------------
class EditarDatosUsuario extends StatefulWidget {
  const EditarDatosUsuario({super.key});

  @override
  State<EditarDatosUsuario> createState() => _EditarDatosUsuarioState();
}

/// Estado de la pantalla EditarDatosUsuario
class _EditarDatosUsuarioState extends State<EditarDatosUsuario> {
  final _formKey = GlobalKey<FormState>(); // Clave para validar el formulario

  // Controladores para manejar los valores de los campos de texto
  late final TextEditingController nombresController;
  late final TextEditingController apellidosController;
  late final TextEditingController telefonoController;
  late final TextEditingController correoController;

  @override
  void initState() {
    super.initState();

    // Inicializar controladores vacíos
    nombresController = TextEditingController();
    apellidosController = TextEditingController();
    telefonoController = TextEditingController();
    correoController = TextEditingController();

    // Cargar datos actuales del usuario desde la API
    _cargarDatosUsuario();
  }

  @override
  void dispose() {
    // Limpiar los controladores para evitar fugas de memoria
    nombresController.dispose();
    apellidosController.dispose();
    telefonoController.dispose();
    correoController.dispose();
    super.dispose();
  }

  /// Función que obtiene los datos actuales del usuario desde la API
  Future<void> _cargarDatosUsuario() async {
    final token = await getToken(); // Obtener token de sesión
    if (token == null) return;

    final response = await http.get(
      Uri.parse(
        'https://plantiq-07xw.onrender.com/api/usuario-actual/editar/',
      ), // Endpoint para obtener datos
      headers: {
        'Authorization': 'Bearer $token', // Autenticación
        'Content-Type': 'application/json',
      },
    );

    // Si la respuesta es correcta, actualizar los controladores con los datos
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        nombresController.text = data['first_name'] ?? '';
        apellidosController.text = data['last_name'] ?? '';
        correoController.text = data['email'] ?? '';
        telefonoController.text = data['telefono'] ?? '';
      });
    }
  }

  /// Función para guardar los datos modificados del usuario
  Future<void> _guardarDatosUsuario() async {
    // Validar formulario antes de enviar
    if (!_formKey.currentState!.validate()) return;

    final token = await getToken();
    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Token no encontrado.')));
      return;
    }

    // Preparar datos del usuario para enviar a la API
    final Map<String, dynamic> userData = {
      'first_name': nombresController.text,
      'last_name': apellidosController.text,
      'email': correoController.text,
      'telefono': telefonoController.text,
    };

    // Llamada PUT a la API para actualizar los datos
    final response = await http.put(
      Uri.parse('https://plantiq-07xw.onrender.com/api/usuario-actual/editar/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userData),
    );

    final colors = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    // Mostrar mensaje de éxito o error según la respuesta
    if (response.statusCode == 200) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.user_save_success,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            backgroundColor: colors.surface,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar los datos'),
            backgroundColor: colors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.secondary,
      appBar: AppBar(
        backgroundColor: colors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          localizations.user_edit_title,
          style: TextStyle(color: colors.onPrimary),
        ),
      ),
      body: Center(
        child: Container(
          width: 900,
          height: 400,
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black, // sombra suave
                blurRadius: 10, // qué tan difusa
                spreadRadius: 2, // expansión
                offset: const Offset(0, 5), // desplazamiento (x,y)
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // ✅ Centrar verticalmente
              crossAxisAlignment:
                  CrossAxisAlignment.center, // ✅ Centrar horizontalmente
              children: [
                _buildTextField(
                  nombresController,
                  localizations.user_first_name,
                  icon: Icons.person,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  apellidosController,
                  localizations.user_last_name,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  telefonoController,
                  localizations.user_phone,
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  correoController,
                  localizations.user_email,
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  isEmail: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _guardarDatosUsuario,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.onSurface,
                    ),
                    child: Text(
                      localizations.user_save,
                      style: TextStyle(color: colors.onPrimary, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget auxiliar para construir un TextField con validación
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    IconData? icon,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    bool isEmail = false,
  }) {
    final colors = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          child: TextFormField(
            controller: controller,
            style: TextStyle(
              color: colors.onSecondary,
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
            cursorColor: colors.onSecondary,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: colors.tertiary,
              prefixIcon: icon != null
                  ? Icon(icon, color: colors.onSecondary, size: 20)
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 12,
              ), // ✅ Ajusta aquí
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colors.onPrimary, width: 1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colors.secondary, width: 1),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return localizations.user_field_required(label.toLowerCase());
              }
              if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return localizations.user_email_invalid;
              }
              return null;
            },
          ),
        );
      },
    );
  }
}

/// -------------------------------------------------------------
/// Clase para editar los datos de la finca
/// -------------------------------------------------------------
class EditarDatosFinca extends StatefulWidget {
  const EditarDatosFinca({super.key});

  @override
  State<EditarDatosFinca> createState() => _EditarDatosFincaState();
}

class _EditarDatosFincaState extends State<EditarDatosFinca> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de los campos
  final TextEditingController nombreFincaController = TextEditingController();
  final TextEditingController direccionFincaController =
      TextEditingController();
  final TextEditingController presentacionController = TextEditingController();

  bool isLoading = true; // Estado de carga mientras se obtienen datos

  @override
  void initState() {
    super.initState();
    _cargarDatosFinca(); // Cargar datos de la finca al iniciar
  }

  /// Simulación de obtención de token (debería usar SharedPreferences o similar)
  Future<String?> getStoredToken() async {
    return 'tu_token_de_ejemplo';
  }

  /// Obtener datos de la finca desde la API
  Future<void> _cargarDatosFinca() async {
    final token = await getStoredToken();
    if (token == null) {
      setState(() => isLoading = false);
      return;
    }

    final response = await http.get(
      Uri.parse('https://plantiq-07xw.onrender.com/api/info_finca/editar/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = response.body.isNotEmpty
          ? (jsonDecode(response.body) as Map<String, dynamic>)
          : null;

      if (data != null && data.isNotEmpty) {
        setState(() {
          nombreFincaController.text = data['nombre'] ?? '';
          direccionFincaController.text = data['direccion'] ?? '';
          presentacionController.text = data['presentacion'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  /// Guardar datos modificados de la finca
  Future<void> _guardarDatosFinca() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await getStoredToken();
    if (token == null) return;

    final Map<String, dynamic> fincaData = {
      'nombre': nombreFincaController.text,
      'direccion': direccionFincaController.text,
      'presentacion': presentacionController.text,
    };

    final response = await http.put(
      Uri.parse('https://plantiq-07xw.onrender.com/api/info_finca/editar/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(fincaData),
    );

    final colors = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.farm_save_success,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            backgroundColor: colors.surface,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.farm_save_error),
            backgroundColor: colors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.secondary,
      appBar: AppBar(
        backgroundColor: colors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          localizations.farm_edit_title,
          style: TextStyle(color: colors.onPrimary),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                width: 900,
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(16),
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
                  behavior: const ScrollBehavior().copyWith(
                    scrollbars: false, // Ocultar la barra
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 600, // Ancho de los inputs
                            child: _buildTextField(
                              nombreFincaController,
                              localizations.farm_name,
                              icon: Icons.landscape,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 600,
                            child: _buildTextField(
                              direccionFincaController,
                              localizations.farm_address,
                              icon: Icons.location_on,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 600,
                            child: _buildTextField(
                              presentacionController,
                              localizations.farm_info,
                              icon: Icons.info_outline,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: _guardarDatosFinca,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.onSurface,
                              ),
                              child: Text(
                                localizations.farm_save,
                                style: TextStyle(
                                  color: colors.onPrimary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  /// Reutilización de TextField para finca (igual que el de usuario)
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    IconData? icon,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final colors = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: colors.onSecondary,
        fontWeight: FontWeight.normal,
        fontSize: 15,
      ),
      cursorColor: colors.onSecondary,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: colors.tertiary,
        prefixIcon: icon != null
            ? Icon(icon, color: colors.onSecondary, size: 20)
            : null,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colors.onPrimary, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colors.secondary, width: 1),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label es requerido';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    // Liberar la memoria ocupada por el controlador del campo "nombre de la finca".
    // Esto es importante para evitar fugas de memoria cuando el widget se destruye.
    nombreFincaController.dispose();

    // Liberar la memoria ocupada por el controlador del campo "dirección de la finca".
    direccionFincaController.dispose();

    // Liberar la memoria ocupada por el controlador del campo "presentación de la finca".
    presentacionController.dispose();

    // Llamar al método dispose de la clase padre (State), que realiza la limpieza final
    // de cualquier recurso gestionado por el ciclo de vida del widget.
    super.dispose();
  }
}
