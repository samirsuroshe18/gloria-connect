import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/notification_service.dart';
import '../../auth/bloc/auth_bloc.dart';
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
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          color: Colors.black.withOpacity(0.2),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              backgroundColor: Colors.transparent,
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              indicatorColor: Colors.amberAccent.shade200.withOpacity(0.4),
              animationDuration: const Duration(milliseconds: 500),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined, color: Colors.white70),
                  selectedIcon: Icon(Icons.person, color: Colors.amberAccent),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.hourglass_empty_outlined, color: Colors.white70),
                  selectedIcon: Icon(Icons.person, color: Colors.amberAccent),
                  label: 'Waiting',
                ),
                NavigationDestination(
                  icon: Icon(Icons.exit_to_app_outlined, color: Colors.white70),
                  selectedIcon: Icon(Icons.person, color: Colors.amberAccent),
                  label: 'Exit',
                ),
                NavigationDestination(
                  icon: Icon(Icons.security_outlined, color: Colors.white70),
                  selectedIcon: Icon(Icons.person, color: Colors.amberAccent),
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