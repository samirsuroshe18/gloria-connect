import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gloria_connect/features/technician_home/screens/technician_pending.dart';
import 'package:gloria_connect/features/technician_home/screens/technician_resolved.dart';
import 'package:gloria_connect/utils/notification_service.dart';

class TechnicianLandingScreen extends StatefulWidget {
  const TechnicianLandingScreen({super.key});

  @override
  State<TechnicianLandingScreen> createState() => _TechnicianLandingScreenState();
}

class _TechnicianLandingScreenState extends State<TechnicianLandingScreen> with SingleTickerProviderStateMixin {
  NotificationAppLaunchDetails? notificationAppLaunchDetails;

  void getInitialAction() async {
    notificationAppLaunchDetails = NotificationController.notificationAppLaunchDetails;
    Map<String, dynamic>? payload;
    if(notificationAppLaunchDetails?.notificationResponse?.payload != null){
      payload = jsonDecode(notificationAppLaunchDetails!.notificationResponse!.payload!);
    }
    if (mounted ) {
      if (notificationAppLaunchDetails != null && payload?['action'] == 'ASSIGN_COMPLAINT') {
        Navigator.pushNamedAndRemoveUntil(context, '/tech-complaint-details-screen', (route) => route.isFirst, arguments: {'id': payload?['id']});
      }else if (notificationAppLaunchDetails != null && payload?['action'] == 'RESOLUTION_APPROVED') {
        Navigator.pushNamedAndRemoveUntil(context, '/tech-complaint-details-screen', (route) => route.isFirst, arguments: {'id': payload?['id']});
      }else if (notificationAppLaunchDetails != null && payload?['action'] == 'RESOLUTION_REJECTED') {
        Navigator.pushNamedAndRemoveUntil(context, '/tech-complaint-details-screen', (route) => route.isFirst, arguments: {'id': payload?['id']});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getInitialAction();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black.withValues(alpha: 0.2),
          title: const Text("Technician Home"),
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: "Pending"),
              Tab(text: "Resolved"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TechnicianPending(),
            TechnicianResolved(),
          ],
        ),
      ),
    );
  }
}