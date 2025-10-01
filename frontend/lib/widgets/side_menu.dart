import 'package:flutter/material.dart';
import 'package:plantiq/generated/l10n.dart';

class HoverMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const HoverMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  _HoverMenuItemState createState() => _HoverMenuItemState();
}

class _HoverMenuItemState extends State<HoverMenuItem> {
  bool _isHovered = false;

  void _onEnter(PointerEvent event) => setState(() => _isHovered = true);
  void _onExit(PointerEvent event) => setState(() => _isHovered = false);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsivo: íconos y texto cambian según el ancho de pantalla
    double iconSize = screenWidth < 800 ? 28 : 40;
    double fontSize = screenWidth < 800 ? 10 : 12;

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: _isHovered ? 0.7 : 1.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: colors.onPrimary, size: iconSize),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: TextStyle(color: colors.onPrimary, fontSize: fontSize),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  final Function(int) onItemSelected;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const SideMenu({super.key, required this.onItemSelected, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          // ✅ Pantallas anchas: menú lateral fijo con sombra derecha
          return Container(
            width: 85,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colors.primary,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(5, 0), // sombra hacia la derecha
                ),
              ],
            ),
            // ✅ Evitamos overflow: si los ítems no caben, se hace scroll
            child: Column(
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      scrollbars: false, // ❌ oculta la barra de scroll
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          HoverMenuItem(
                            icon: Icons.person,
                            label: localizations.menuProfile,
                            onTap: () => onItemSelected(0),
                          ),
                          const SizedBox(height: 220),
                          HoverMenuItem(
                            icon: Icons.eco,
                            label: localizations.menuIrrigations,
                            onTap: () => onItemSelected(1),
                          ),
                          const SizedBox(height: 20),
                          HoverMenuItem(
                            icon: Icons.equalizer,
                            label: localizations.menuStats,
                            onTap: () => onItemSelected(2),
                          ),
                          const SizedBox(height: 20),
                          HoverMenuItem(
                            icon: Icons.apps,
                            label: localizations.menuSystem,
                            onTap: () => onItemSelected(3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // ✅ Ajustamos configuración al fondo
                HoverMenuItem(
                  icon: Icons.settings,
                  label: localizations.menuSettings,
                  onTap: () => onItemSelected(4),
                ),
              ],
            ),
          );
        } else {
          // ✅ Pantallas pequeñas: botón hamburguesa
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFFE3E3E3)),
              onPressed: () {
                if (scaffoldKey != null && scaffoldKey!.currentState != null) {
                  scaffoldKey!.currentState!.openDrawer();
                }
              },
              tooltip: localizations.menuTooltip,
            ),
          );
        }
      },
    );
  }
}
