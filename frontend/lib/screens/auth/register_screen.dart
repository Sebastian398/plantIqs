import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plantiq/main.dart';
import './login_screen.dart';
import 'package:plantiq/generated/l10n.dart';

class SimpleHoverButton extends StatefulWidget {
  // añade al estado de tu StatefulWidget
  final VoidCallback onTap;
  final Widget child;
  const SimpleHoverButton({
    required this.onTap,
    required this.child,
    super.key,
  });

  @override
  _SimpleHoverButtonState createState() => _SimpleHoverButtonState();
}

class _SimpleHoverButtonState extends State<SimpleHoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          /// ✅ Animación suave entre estados hover / normal
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isHovered
                ? colors.onSurface.withOpacity(0.9) // hover un poco más claro
                : colors.onSurface, // color normal
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: _isHovered ? 15 : 15, // más sombra en hover
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          child: DefaultTextStyle(
            /// ✅ Asegura que el texto dentro se vea bien
            style: TextStyle(
              color: colors.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class SimpleHoverLink extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final Color normalColor;
  final Color hoverColor;
  const SimpleHoverLink({
    required this.onTap,
    required this.text,
    required this.normalColor,
    required this.hoverColor,
    super.key,
  });
  @override
  _SimpleHoverLinkState createState() => _SimpleHoverLinkState();
}

class _SimpleHoverLinkState extends State<SimpleHoverLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // 👆 cambia cursor
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _isHovered ? widget.hoverColor : widget.normalColor,
            decoration: TextDecoration.none, // ✅ subrayado en hover
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  Future<void> _submitForm() async {
    final loc = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url = Uri.parse('https://plantiq-07xw.onrender.com/api/register/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "first_name": _nombresController.text.trim(),
        "last_name": _apellidosController.text.trim(),
        "email": _emailController.text.trim(),
        "telefono": _telefonoController.text.trim(),
        "password": _passwordController.text.trim(),
        "password2": _confirmpasswordController.text.trim(),
      }),
    );
    if (response.statusCode != 201) {
      print('Response error body: ${response.body}');
    }

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      try {
        final data = jsonDecode(response.body);
        setState(() {
          if (data is Map && data.isNotEmpty) {
            _errorMessage = data.values.first is List
                ? (data.values.first as List).first.toString()
                : data.values.first.toString();
          } else {
            _errorMessage = loc.registerErrorUnknown;
          }
        });
      } catch (_) {
        setState(() {
          _errorMessage = loc.registerErrorServer;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.secondary,
      body: SafeArea(
        child: Center(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false, // ❌ oculta la barra de scroll
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black, // sombra suave
                        blurRadius: 10, // qué tan difusa
                        spreadRadius: 2, // expansión
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  width: 600,
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaginaInicio(),
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/images/Logo_blanco.png',
                          width: 350,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        loc.registerTitle,
                        style: TextStyle(
                          color: colors.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 25),

                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),

                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ==================== CAMPO: NOMBRES ====================
                            _buildInput(
                              _nombresController,
                              loc.firstNameLabel,
                              Icons.person,
                              loc.firstNameError,
                            ),

                            const SizedBox(height: 30),

                            // ==================== CAMPO: APELLIDOS ====================
                            _buildInput(
                              _apellidosController,
                              loc.lastNameLabel,
                              Icons.person,
                              loc.lastNameError,
                            ),

                            const SizedBox(height: 30),

                            // ==================== CAMPO: TELÉFONO ====================
                            TextFormField(
                              controller: _telefonoController,
                              style: TextStyle(
                                color: colors.onSecondary,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                              cursorColor: colors.onSecondary,
                              decoration: InputDecoration(
                                labelText: loc.phoneLabel,
                                labelStyle: TextStyle(
                                  color: colors.onSecondary,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: colors.onSecondary,
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: colors.tertiary,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: colors.onPrimary,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: colors.secondary,
                                    width: 1,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return loc.phoneErrorEmpty;
                                }
                                if (!RegExp(
                                  r'^\+?[0-9\s\-]{7,15}$',
                                ).hasMatch(value)) {
                                  return loc.phoneErrorInvalid;
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                            ),

                            const SizedBox(height: 30),

                            // ==================== CAMPO: EMAIL ====================
                            TextFormField(
                              controller: _emailController,
                              style: TextStyle(
                                color: colors.onSecondary,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                              cursorColor: colors.onSecondary,
                              decoration: InputDecoration(
                                labelText: loc.emailLabelRe,
                                labelStyle: TextStyle(
                                  color: colors.onSecondary,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: colors.onSecondary,
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: colors.tertiary,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: colors.onPrimary,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: colors.secondary,
                                    width: 1,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return loc.emailErrorEmptyRe;
                                }
                                if (!value.contains('@')) {
                                  return loc.emailErrorInvalidRe;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 30),

                            // CONTRASEÑA
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: TextStyle(
                                color: colors.onSecondary,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                              cursorColor: colors.onSecondary,
                              decoration: InputDecoration(
                                labelText: loc.passwordLabelRe,
                                labelStyle: TextStyle(
                                  color: colors.onSecondary,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                                prefixIcon: Icon(
                                  Icons.password,
                                  color: colors.onSecondary,
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: colors.tertiary,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: colors.onPrimary,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: colors.secondary,
                                    width: 1,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    );
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: colors.onSecondary,
                                    size: 20,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return loc.passwordErrorEmptyRe;
                                }
                                if (value.length < 6) {
                                  return loc.passwordErrorShortRe;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),

                            // CONFIRMAR CONTRASEÑA
                            TextFormField(
                              controller: _confirmpasswordController,
                              obscureText: _obscureConfirm,
                              style: TextStyle(
                                color: colors.onSecondary,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                              cursorColor: colors.onSecondary,
                              decoration: InputDecoration(
                                labelText: loc.confirmPasswordLabel,
                                labelStyle: TextStyle(
                                  color: colors.onSecondary,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                                prefixIcon: Icon(
                                  Icons.password,
                                  color: colors.onSecondary,
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: colors.tertiary,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: colors.onPrimary,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: colors.secondary,
                                    width: 1,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(
                                      () => _obscureConfirm = !_obscureConfirm,
                                    );
                                  },
                                  icon: Icon(
                                    _obscureConfirm
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: colors.onSecondary,
                                    size: 20,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return loc.confirmPasswordErrorEmpty;
                                }
                                if (value != _passwordController.text) {
                                  return loc.confirmPasswordErrorMismatch;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 40),

                            // ==================== BOTÓN REGISTRARSE ====================
                            Center(
                              child: SimpleHoverButton(
                                onTap: _isLoading ? () {} : _submitForm,
                                child: Text(loc.registerButton),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ==================== LINK A LOGIN ====================
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(color: colors.onPrimary),
                                  children: [
                                    TextSpan(text: loc.alreadyHaveAccount),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: SimpleHoverLink(
                                        text: loc.loginHere,
                                        normalColor: colors.onSurface,
                                        hoverColor: colors.onPrimary,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String label,
    IconData icon,
    String error,
  ) {
    final colors = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      cursorColor: colors.onSecondary, // color del cursor
      style: TextStyle(
        color: colors.onSecondary,
        fontWeight: FontWeight.normal, // color del texto que escribes
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: colors.onSecondary,
          fontWeight: FontWeight.normal, // color del label flotante
          fontSize: 15,
        ),
        prefixIcon: Icon(icon, color: colors.onSecondary, size: 23),
        filled: true,
        fillColor: colors.tertiary, // icono blanco
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colors.onPrimary,
            width: 1,
          ), // borde normal
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colors.secondary, width: 1),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return error;
        return null;
      },
    );
  }
}
