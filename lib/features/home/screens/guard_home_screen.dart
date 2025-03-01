// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gloria_connect/features/auth/bloc/auth_bloc.dart';
//
// import '../../../utils/notification_service.dart';
// import '../../guard_entry/screens/guard_entry_screen.dart';
// import '../../guard_exit/screens/guard_exit_screen.dart';
// import '../../guard_profile/screens/guard_profile_screen.dart';
// import '../../guard_waiting/screens/guard_waiting_screen.dart';
//
// class GuardHomeScreen extends StatefulWidget {
//   const GuardHomeScreen({super.key});
//
//   @override
//   State<GuardHomeScreen> createState() => _GuardHomeScreenState();
// }
//
// class _GuardHomeScreenState extends State<GuardHomeScreen> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _guardPages = [
//     const GuardEntryScreen(),
//     const GuardWaitingScreen(),
//     const GuardExitScreen(),
//     const GuardProfileScreen(),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     NotificationController().requestNotificationPermission();
//     // NotificationController().updateDeviceToken(context);
//     // Schedule the listener setup in the microtask queue to ensure context is ready.
//     Future.microtask(() {
//       FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//         if (mounted) {
//           context.read<AuthBloc>().add(AuthUpdateFCM(FCMToken: newToken));
//         }
//       });
//     });
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _guardPages,
//       ),
//       bottomNavigationBar: SizedBox(
//         height: 70,
//         child: ClipRRect(
//           borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(40), topRight: Radius.circular(40)),
//           child: BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             backgroundColor: const Color.fromARGB(255, 193, 209, 240),
//             iconSize: 20.0,
//             selectedIconTheme: const IconThemeData(size: 28.0),
//             selectedItemColor: const Color.fromARGB(255, 46, 90, 172),
//             unselectedItemColor: Colors.black,
//             selectedFontSize: 16.0,
//             unselectedFontSize: 12,
//             currentIndex: _selectedIndex,
//             onTap: _onItemTapped,
//             items: const <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.hourglass_empty),
//                 label: 'Waiting',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.exit_to_app),
//                 label: 'Exit',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.security),
//                 label: 'Profile',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/admin_profile/screens/admin_profile_screen.dart';
import 'package:gloria_connect/features/administration/screens/administration_screen.dart';
import 'package:gloria_connect/features/invite_visitors/screens/invite_visitors_screen.dart';
import 'package:gloria_connect/features/my_visitors/screens/my_visitors_screen.dart';

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
    NotificationController().requestNotificationPermission();
    // NotificationController().updateDeviceToken(context);
    // Schedule the listener setup in the microtask queue to ensure context is ready.
    Future.microtask(() {
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        if (mounted) {
          context.read<AuthBloc>().add(AuthUpdateFCM(FCMToken: newToken));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.blue,
      //   title: Row(
      //     children: [
      //       Image.asset('assets/app_logo/app_logo.png', height: 40),
      //       const SizedBox(width: 8),
      //       const Text(
      //         'Gloria Connect',
      //         style: TextStyle(
      //           color: Colors.white,
      //           fontSize: 24,
      //         ),
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.notifications_outlined, color: Colors.white),
      //       onPressed: () {
      //         // Handle notifications
      //       },
      //     ),
      //     const SizedBox(width: 8),
      //   ],
      // ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _guardPages,
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
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home, color: Color(0xFF1A237E)),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.hourglass_empty_outlined),
                  selectedIcon: Icon(Icons.hourglass_empty, color: Color(0xFF1A237E)),
                  label: 'Waiting',
                ),
                NavigationDestination(
                  icon: Icon(Icons.exit_to_app_outlined),
                  selectedIcon: Icon(Icons.exit_to_app, color: Color(0xFF1A237E)),
                  label: 'Exit',
                ),
                NavigationDestination(
                  icon: Icon(Icons.security_outlined),
                  selectedIcon: Icon(Icons.security, color: Color(0xFF1A237E)),
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