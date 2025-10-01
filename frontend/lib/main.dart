import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plantiq/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'package:plantiq/theme.dart';
import 'package:plantiq/widgets/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

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

// Provider para manejar el estado del idioma
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('es');

  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    if (_locale == newLocale) return;
    _locale = newLocale;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Página de Inicio',
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const PaginaInicio(),
    );
  }
}

class PaginaInicio extends StatefulWidget {
  const PaginaInicio({super.key});

  @override
  State<PaginaInicio> createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  late Locale selectedLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedLocale = Localizations.localeOf(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.secondary,
      body: SafeArea(
        child: Stack(
          children: [
            // 📌 Contenido principal
            Center(
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
                    height: 500,
                    width: 700,
                    child: Stack(
                      children: [
                        // ✅ Contenido principal (centrado)
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/Logo_blanco.png',
                                width: 350,
                              ),
                              const SizedBox(height: 32),

                              Text(
                                loc.slogan,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: colors.onPrimary,
                                ),
                              ),
                              const SizedBox(height: 16),

                              Text(
                                loc.description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colors.onPrimary,
                                ),
                              ),
                              const SizedBox(height: 40),

                              ElevatedButton(
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.symmetric(
                                      horizontal: 35,
                                      vertical: 12,
                                    ),
                                  ),
                                  backgroundColor: WidgetStateProperty.all(
                                    colors.onSurface,
                                  ),
                                  foregroundColor: WidgetStateProperty.all(
                                    colors.onPrimary,
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  loc.startButton,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // ✅ Enlace de registro (centrado)
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    color: colors.onPrimary,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(text: loc.notRegistered),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: HoverText(
                                        text: loc.here,
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
                            ],
                          ),
                        ),

                        // ✅ Botones abajo a la derecha, uno al lado del otro
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Row(
                            children: [
                              Consumer<ThemeProvider>(
                                builder: (context, themeProvider, _) =>
                                    IconButton(
                                      iconSize: 20,
                                      color: colors.onPrimary,
                                      style: ButtonStyle(),
                                      onPressed: () {
                                        themeProvider.toggleTheme();
                                      },
                                      icon: Icon(
                                        themeProvider.themeMode ==
                                                ThemeMode.dark
                                            ? Icons.wb_sunny
                                            : Icons.nights_stay,
                                      ),
                                    ),
                              ),
                              const SizedBox(width: 4),
                              Consumer<LocaleProvider>(
                                builder: (context, localeProvider, _) =>
                                    IconButton(
                                      iconSize: 20,
                                      color: colors.onPrimary,
                                      style: ButtonStyle(),
                                      onPressed: () {
                                        final newLocale =
                                            localeProvider
                                                    .locale
                                                    .languageCode ==
                                                'es'
                                            ? const Locale('en')
                                            : const Locale('es');
                                        localeProvider.setLocale(newLocale);
                                      },
                                      icon: Icon(
                                        localeProvider.locale.languageCode ==
                                                'es'
                                            ? Icons.language
                                            : Icons.translate,
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
          ],
        ),
      ),
    );
  }
}
