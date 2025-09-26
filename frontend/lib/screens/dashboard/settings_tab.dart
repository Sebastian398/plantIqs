import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:plantiq/screens/auth/mail_reset.dart';
import 'package:plantiq/widgets/theme_provider.dart';
import 'package:plantiq/main.dart';
import 'package:plantiq/generated/l10n.dart';
import 'package:plantiq/screens/auth/login_screen.dart';

Future<String?> getStoredToken() async {
  // Aquí debes implementar la lógica real para obtener el token guardado (SharedPreferences, flutter_secure_storage, etc.)
  return 'tu_token_de_ejemplo';
}

Future<void> clearStoredToken() async {}

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool modoClaro = false;

  Future<void> logout() async {
    final token = await getStoredToken();
    if (token == null) return;

    final response = await http.post(
      Uri.parse(
        'http://localhost:8000/api/logout/',
      ), // Cambia a tu URL real logout
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    final localizations = AppLocalizations.of(context);

    if (response.statusCode == 200) {
      await clearStoredToken();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.settings_logout_error)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: true);
    final colors = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.surface,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              localizations.settings_title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.language), // ícono idioma
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<Locale>(
                    value: localeProvider.locale,
                    items: AppLocalizations.delegate.supportedLocales.map((
                      locale,
                    ) {
                      String name;
                      switch (locale.languageCode) {
                        case 'es':
                          name = 'Español';
                          break;
                        case 'en':
                          name = 'English';
                          break;
                        default:
                          name = locale.languageCode;
                      }
                      return DropdownMenuItem(value: locale, child: Text(name));
                    }).toList(),
                    onChanged: (Locale? locale) {
                      if (locale != null) {
                        localeProvider.setLocale(locale);
                      }
                    },
                    isExpanded: true,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.light_mode, color: colors.tertiary),
            title: Text(
              localizations.settings_light_mode,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.light,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ),
          Divider(color: colors.tertiary),
          ListTile(
            leading: Icon(Icons.person, color: colors.tertiary),
            title: Text(
              localizations.settings_user_data,
              style: Theme.of(context).textTheme.bodyLarge,
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
          ListTile(
            leading: Icon(Icons.agriculture, color: colors.tertiary),
            title: Text(
              localizations.settings_farm_data,
              style: Theme.of(context).textTheme.bodyLarge,
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
          ListTile(
            leading: Icon(Icons.lock, color: colors.tertiary),
            title: Text(
              localizations.settings_auth,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: colors.surface,
                  title: Text(
                    localizations.settings_auth_options,
                    style: TextStyle(color: colors.tertiary),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            colors.surface,
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
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            colors.surface,
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
                          style: const TextStyle(
                            color: Color.fromARGB(255, 191, 37, 37),
                          ),
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
    );
  }
}

class EditarDatosUsuario extends StatefulWidget {
  const EditarDatosUsuario({super.key});

  @override
  State<EditarDatosUsuario> createState() => _EditarDatosUsuarioState();
}

class _EditarDatosUsuarioState extends State<EditarDatosUsuario> {
  final _formKey = GlobalKey<FormState>();

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

    // Cargar datos actuales del usuario
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

  Future<void> _cargarDatosUsuario() async {
    final token = await getToken();
    if (token == null) {
      return;
    }
    final response = await http.get(
      Uri.parse('http://localhost:8000/api/usuario-actual/editar/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
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

  Future<void> _guardarDatosUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await getToken();
    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Token no encontrado.')));
      return;
    }

    final Map<String, dynamic> userData = {
      'first_name': nombresController.text,
      'last_name': apellidosController.text,
      'email': correoController.text,
      'telefono': telefonoController.text,
    };

    final response = await http.put(
      Uri.parse('http://localhost:8000/api/usuario-actual/editar/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userData),
    );

    final colors = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

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
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.tertiary),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: '',
        ),
        title: Text(
          localizations.user_edit_title,
          style: TextStyle(color: colors.tertiary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                nombresController,
                localizations.user_first_name,
                icon: Icons.person,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                apellidosController,
                localizations.user_last_name,
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                telefonoController,
                localizations.user_phone,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                correoController,
                localizations.user_email,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                isEmail: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardarDatosUsuario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                ),
                child: Text(
                  localizations.user_save,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: isHovered
                  ? colors.surface.withOpacity(0.9)
                  : colors.surface,
              prefixIcon: icon != null ? Icon(icon) : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.tertiary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.tertiary, width: 2),
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

class EditarDatosFinca extends StatefulWidget {
  const EditarDatosFinca({super.key});

  @override
  State<EditarDatosFinca> createState() => _EditarDatosFincaState();
}

class _EditarDatosFincaState extends State<EditarDatosFinca> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreFincaController = TextEditingController();
  final TextEditingController direccionFincaController =
      TextEditingController();
  final TextEditingController presentacionController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosFinca();
  }

  Future<String?> getStoredToken() async {
    return 'tu_token_de_ejemplo';
  }

  Future<void> _cargarDatosFinca() async {
    final token = await getStoredToken();
    if (token == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final response = await http.get(
      Uri.parse('http://localhost:8000/api/info_finca/editar/'),
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
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

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
      Uri.parse('http://localhost:8000/api/info_finca/editar/'),
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
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: '',
        ),
        title: Text(
          localizations.farm_edit_title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField(
                      nombreFincaController,
                      localizations.farm_name,
                      icon: Icons.landscape,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      direccionFincaController,
                      localizations.farm_address,
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      presentacionController,
                      localizations.farm_info,
                      icon: Icons.info_outline,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _guardarDatosFinca,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                      ),
                      child: Text(
                        localizations.farm_save,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    IconData? icon,
    String? hintText,
  }) {
    final colors = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);
    return TextFormField(
      controller: controller,
      style: TextStyle(color: colors.tertiary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        filled: true,
        fillColor: colors.surface,
        prefixIcon: icon != null ? Icon(icon, color: colors.tertiary) : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.tertiary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.tertiary),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return localizations.farm_field_required(label.toLowerCase());
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    nombreFincaController.dispose();
    direccionFincaController.dispose();
    presentacionController.dispose();
    super.dispose();
  }
}
