import 'package:flutter/material.dart';

import '../../../utils/notification_service.dart';
import '../../guard_entry/screens/guard_entry_screen.dart';
import '../../guard_exit/screens/guard_exit_screen.dart';
import '../../guard_profile/screens/guard_profile_screen.dart';
import '../../guard_waiting/screens/guard_waiting_screen.dart';

class GuardHomeScreen extends StatefulWidget {
  const GuardHomeScreen({super.key});
  @override
  State<GuardHomeScreen> createState() => _GuardHomeScreenState();
}

class _GuardHomeScreenState extends State<GuardHomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _guardPages = [
    const GuardEntryScreen(),
    const GuardWaitingScreen(),
    const GuardExitScreen(),
    const GuardProfileScreen(),
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
      key: _scaffoldKey,body: IndexedStack(
        index: _selectedIndex,
        children: _guardPages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
          // A gradient that complements your background but stays more subtle
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.shade900.withOpacity(0.85),
              Colors.deepPurple.shade900.withOpacity(0.85),
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
              indicatorColor: Colors.white.withOpacity(0.12), // More subtle indicator
              animationDuration: const Duration(milliseconds: 400),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined, color: Colors.white70, size: 24),
                  selectedIcon: Icon(Icons.home, color: Colors.white, size: 24),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.hourglass_empty_outlined, color: Colors.white70, size: 24),
                  selectedIcon: Icon(Icons.hourglass_bottom, color: Colors.white, size: 24),
                  label: 'Waiting',
                ),
                NavigationDestination(
                  icon: Icon(Icons.exit_to_app_outlined, color: Colors.white70, size: 24),
                  selectedIcon: Icon(Icons.exit_to_app, color: Colors.white, size: 24),
                  label: 'Exit',
                ),
                NavigationDestination(
                  icon: Icon(Icons.security_outlined, color: Colors.white70, size: 24),
                  selectedIcon: Icon(Icons.security, color: Colors.white, size: 24),
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