import 'package:flutter/material.dart';
import 'package:gloria_connect/features/technician_home/screens/technician_pending.dart';
import 'package:gloria_connect/features/technician_home/screens/technician_resolved.dart';

class TechnicianLandingScreen extends StatefulWidget {
  const TechnicianLandingScreen({super.key});

  @override
  State<TechnicianLandingScreen> createState() => _TechnicianLandingScreenState();
}

class _TechnicianLandingScreenState extends State<TechnicianLandingScreen> with SingleTickerProviderStateMixin {
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