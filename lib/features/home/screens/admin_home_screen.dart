import 'package:flutter/material.dart';
import 'package:gloria_connect/features/admin_profile/screens/admin_profile_screen.dart';
import 'package:gloria_connect/features/administration/screens/administration_screen.dart';
import 'package:gloria_connect/features/home/screens/landing_screen.dart';

import '../../../utils/notification_service.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _adminPages = [
    const LandingScreen(),
    const AdministrationScreen(),
    const AdminProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    final notificationServices = NotificationController();
    await notificationServices.requestNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: IndexedStack(
        index: _selectedIndex,
        children: _adminPages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
          // A gradient that complements your background but stays more subtle
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.shade900.withValues(alpha: 0.85),
              Colors.deepPurple.shade900.withValues(alpha: 0.85),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              height: 60,
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              indicatorColor: Colors.white.withValues(alpha: 0.12), // More subtle indicator
              animationDuration: const Duration(milliseconds: 400),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined, color: Colors.white70, size: 24),
                  selectedIcon: Icon(Icons.home, color: Colors.white, size: 24),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.admin_panel_settings_outlined, color: Colors.white70, size: 24),
                  selectedIcon: Icon(Icons.admin_panel_settings, color: Colors.white, size: 24),
                  label: 'Admin',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline, color: Colors.white70, size: 24),
                  selectedIcon: Icon(Icons.person, color: Colors.white, size: 24),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}