import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/admin_profile/screens/admin_profile_screen.dart';
import 'package:gloria_connect/features/administration/screens/administration_screen.dart';
import 'package:gloria_connect/features/invite_visitors/screens/invite_visitors_screen.dart';
import 'package:gloria_connect/features/my_visitors/screens/my_visitors_screen.dart';

import '../../../utils/notification_service.dart';
import '../../auth/bloc/auth_bloc.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _adminPages = [
    const MyVisitorsScreen(),
    const InviteVisitorsScreen(),
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
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/app_logo/app_logo.png', height: 40),
            const SizedBox(width: 8),
            const Text(
              'Gloria Connect',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // Handle notifications
              Navigator.pushNamed(context, '/general-notice-board-screen');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _adminPages,
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
              backgroundColor: Colors.transparent, // Keeps the gradient visible
              elevation: 0,
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              indicatorColor: Colors.amberAccent.shade200.withOpacity(0.4), // Elegant gold accent
              animationDuration: const Duration(milliseconds: 500),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.people_outline, color: Colors.white70),
                  selectedIcon: Icon(Icons.people, color: Colors.amberAccent),
                  label: 'Visitors',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_add_outlined, color: Colors.white70),
                  selectedIcon: Icon(Icons.person_add, color: Colors.amberAccent),
                  label: 'Invite',
                ),
                NavigationDestination(
                  icon: Icon(Icons.admin_panel_settings_outlined, color: Colors.white70),
                  selectedIcon: Icon(Icons.admin_panel_settings, color: Colors.amberAccent),
                  label: 'Admin',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline, color: Colors.white70),
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