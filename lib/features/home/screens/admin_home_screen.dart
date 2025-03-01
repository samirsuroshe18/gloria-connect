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

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      if (mounted) {
        context.read<AuthBloc>().add(AuthUpdateFCM(FCMToken: newToken));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
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
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
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
              backgroundColor: Colors.white,
              elevation: 0,
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              animationDuration: const Duration(milliseconds: 500),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people, color: Color(0xFF1A237E)),
                  label: 'Visitors',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_add_outlined),
                  selectedIcon: Icon(Icons.person_add, color: Color(0xFF1A237E)),
                  label: 'Invite',
                ),
                NavigationDestination(
                  icon: Icon(Icons.admin_panel_settings_outlined),
                  selectedIcon: Icon(Icons.admin_panel_settings, color: Color(0xFF1A237E)),
                  label: 'Admin',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person, color: Color(0xFF1A237E)),
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