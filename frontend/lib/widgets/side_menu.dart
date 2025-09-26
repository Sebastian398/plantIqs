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
            children: [
              Icon(widget.icon, color: colors.tertiary, size: 40),
              const SizedBox(height: 1),
              Text(
                widget.label,
                style: TextStyle(color: colors.tertiary, fontSize: 12),
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
          // Pantallas anchas: menú lateral fijo
          return Container(
            width: 85,
            color: colors.surface,
            padding: const EdgeInsets.all(6),
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
                const Spacer(),
                HoverMenuItem(
                  icon: Icons.settings,
                  label: localizations.menuSettings,
                  onTap: () => onItemSelected(4),
                ),
              ],
            ),
          );
        } else {
          // Pantallas pequeñas: menú oculto, usa Drawer y botón hamburguesa
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
