// lib/screens/dashboard/dashboard_screen.dart

import 'package:flutter/material.dart';
import '../dashboard/profile_tab.dart';
import '../dashboard/settings_tab.dart';
import '../dashboard/system_tap.dart';
import '../dashboard/statistics_tab.dart';
import '../dashboard/risks.dart';
import '../../widgets/side_menu.dart';
import '../auth/login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? token;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  Future<void> loadToken() async {
    token = await getToken();
    setState(() {}); // Para reconstruir y pasar token actualizado
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    final List<Widget> screens = [
    ProfileTab(token: token),
    RisksListScreen(),
    StatisticsTab(),
    SystemTap(),
    SettingsTab(),
    ];
    
    return Scaffold(
      body: Row(
        children: [
          SideMenu(onItemSelected: _onItemSelected),
          Expanded(
            child: Container(
              color: colors.surface,
              child: screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
