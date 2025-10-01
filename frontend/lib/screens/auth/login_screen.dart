import 'register_screen.dart';
import 'package:plantiq/main.dart';
import '../dashboard/dashboard_screen.dart';
import '../auth/mail_reset.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:plantiq/generated/l10n.dart';

class SimpleHoverButton extends StatefulWidget {
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
    super.key}
  );
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
            decoration:TextDecoration.none, // ✅ subrayado en hover
          ),
        ),
      ),
    );
  }
}

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
  print('Token guardado: $token');
}

Future<void> saveRefreshToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('refresh_token', token);
  print('Refresh token guardado: $token');
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  print('Token recuperado: $token');
  return token;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

    bool _obscurePassword = true;

  Future<void> _submitForm() async {
    final loc = AppLocalizations.of(context);
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      try {
        final response = await http.post(
          Uri.parse('https://plantiq-07xw.onrender.com/api/login/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': email, 'password': password}),
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final accessToken = data['access'];
          final refreshToken = data['refresh'] ?? '';
          if (accessToken != null) {
            await saveToken(accessToken);
            await saveRefreshToken(refreshToken);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          } else {
            _showErrorDialog(loc.errorNoToken);
          }
        } else {
          final errorData = json.decode(response.body);
          String errorMessage = loc.errorDefault;
          if (errorData.containsKey('email')) {
            errorMessage = errorData['email'].toString();
          } else if (errorData.containsKey('password')) {
            errorMessage = errorData['password'].toString();
          } else if (errorData.containsKey('detail')) {
            errorMessage = errorData['detail'].toString();
          }
          _showErrorDialog(errorMessage);
        }
      } catch (e) {
        _showErrorDialog(loc.errorConnection);
      }
    }
  }

  void _showErrorDialog(String message) {
    final loc = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.errorDialogTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.secondary,
      body: SafeArea(
        child: Center(
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
                      offset: const Offset(0, 5), // desplazamiento (x,y)
                    ),
                  ],
                ),
                width: 600,
                height: 600,
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
                      loc.loginTitle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 25),

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            style: TextStyle(
                              color: colors.onSecondary,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                            cursorColor: colors.onSecondary,
                            decoration: InputDecoration(
                              labelText: loc.emailLabel,
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
                              // Línea blanca cuando está deshabilitado o sin foco
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colors.onPrimary,
                                  width: 1,
                                ),
                              ),
                              // Línea cuando está enfocado
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colors.secondary,
                                  width: 1,
                                ),
                              ),
                              // Línea azul cuando tiene el foco
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return loc.emailErrorEmpty;
                              }
                              if (!value.contains('@')) {
                                return loc.emailErrorInvalid;
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 30),

                          /// 🔒 Contraseña con ojito 👁️
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
                              labelText: loc.passwordLabel,
                              labelStyle: TextStyle(
                                color: colors.onSecondary,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: colors.onSecondary,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: colors.onSecondary,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
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
                                return loc.passwordErrorEmpty;
                              }
                              if (value.length < 6) {
                                return loc.passwordErrorShort;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: SimpleHoverButton(
                              onTap: _submitForm,
                              child: Text(loc.loginButton),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(color: colors.onPrimary, fontSize: 16),
                                children: [
                                  TextSpan(
                                    text: loc.registerPrompt
                                  ),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: SimpleHoverLink(
                                      text: loc.registerHere,
                                      normalColor: colors.onSurface,
                                      hoverColor: colors.onPrimary,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                              const RegisterScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(color: colors.onPrimary, fontSize: 16),
                                children: [
                                  TextSpan(text: loc.forgotPasswordPrompt),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: SimpleHoverLink(
                                      text: loc.registerHere,
                                      normalColor: colors.onSurface,
                                      hoverColor: colors.onPrimary,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                              const MailResetScreen(),
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
    );
  }
}
