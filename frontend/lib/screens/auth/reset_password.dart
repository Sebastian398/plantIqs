import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register_screen.dart';
import 'package:plantiq/main.dart';
import '../auth/login_screen.dart';
import 'package:plantiq/generated/l10n.dart';

class HoverText extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color normalColor;
  final Color hoverColor;

  const HoverText({
    super.key,
    required this.text,
    required this.onTap,
    required this.normalColor,
    required this.hoverColor,
  });

  @override
  State<HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
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
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isHovered = false;
  bool _isLoading = false;

  Future<bool> resetPassword({
    required String token,
    required String password,
  }) async {
    final url = Uri.parse(
      'https://plantiq-07xw.onrender.com/api/password_reset/confirm/',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'password': password}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error reset password: ${response.body}');
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      final snackBar = SnackBar(
        content: Text(errorData['error'] ?? 'Error al restablecer contraseña'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      bool success = await resetPassword(
        token: _tokenController.text,
        password: _passwordController.text,
      );
      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Se restableció la contraseña correctamente'),
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
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
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 600,
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
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
                      localizations.resetPasswordTitlePas,
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Campo Token
                          TextFormField(
                            controller: _tokenController,
                            style: TextStyle(
                              color: colors.onSecondary,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                            cursorColor: colors.onSecondary,
                            decoration: InputDecoration(
                              labelText: 'Token',
                              labelStyle: TextStyle(
                                color: colors.onSecondary,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                              prefixIcon: Icon(
                                Icons.confirmation_number,
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
                                return 'El token es obligatorio';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Campo Contraseña
                          TextFormField(
                            controller: _passwordController,
                            style: TextStyle(
                              color: colors.onSecondary,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                            cursorColor: colors.onSecondary,
                            decoration: InputDecoration(
                              labelText: localizations.passwordLabelPas,
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
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localizations.passwordEmptyError;
                              }
                              if (value.length < 8) {
                                return localizations.passwordTooShortError;
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 40),

                          // BOTÓN
                          Center(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (_) => setState(() => _isHovered = true),
                              onExit: (_) => setState(() => _isHovered = false),
                              child: GestureDetector(
                                onTap: _submitForm,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 26,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _isHovered
                                        ? colors.onSurface.withOpacity(0.85)
                                        : colors.onSurface,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: _isHovered ? 8 : 16,
                                        offset: const Offset(2, 4),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    localizations.resetButton,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: colors.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // enlaces
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: colors.onPrimary,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text: localizations.notRegisteredPas,
                                  ),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: HoverText(
                                      text: localizations.herePas,
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
                                style: TextStyle(
                                  color: colors.onPrimary,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(text: localizations.loginTextPas),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: HoverText(
                                      text: localizations.herePas,
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
    );
  }
}
