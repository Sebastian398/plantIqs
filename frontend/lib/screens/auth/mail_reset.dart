import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register_screen.dart';
import '../auth/login_screen.dart';
import 'package:plantiq/main.dart';
import 'package:plantiq/generated/l10n.dart';
import '../auth/reset_password.dart';

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
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
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

class MailResetScreen extends StatefulWidget {
  const MailResetScreen({super.key});
  @override
  State<MailResetScreen> createState() => _MailResetScreen();
}

class _MailResetScreen extends State<MailResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  Future<bool> sendResetEmail(String email) async {
    final url = Uri.parse(
      'https://plantiq-07xw.onrender.com/api/password_reset/',
    );
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void _submitForm() async {
    final localizations = AppLocalizations.of(context);
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      bool success = await sendResetEmail(_emailController.text.trim());
      setState(() {
        _isLoading = false;
      });
      if (success) {
        // Navegar a reset_password solo si éxito
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
        );
      } else {
        // Mostrar error al usuario
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(localizations.resetError)));
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                width: 600,
                height: 500,
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
                      localizations.resetPasswordTitle,
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
                          TextFormField(
                            controller: _emailController,
                            style: TextStyle(
                              color: colors.onSecondary,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                            cursorColor: colors.onSecondary,
                            decoration: InputDecoration(
                              labelText: localizations.emailLabelRes,
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
                              // Línea cuando está enfocado
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colors.secondary,
                                  width: 1,
                                ),
                              ),
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localizations.emailRequired;
                              }
                              if (!value.contains('@')) {
                                return localizations.emailInvalid;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : SimpleHoverButton(
                                    onTap: _submitForm,
                                    child: Text(localizations.sendEmail),
                                  ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: colors.onPrimary,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text: localizations.notRegisteredRes,
                                  ),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: SimpleHoverLink(
                                      text: localizations.hereRes,
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
                                  TextSpan(text: localizations.loginText),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: SimpleHoverLink(
                                      text: localizations.hereRes,
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
