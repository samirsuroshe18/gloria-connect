import 'package:flutter/material.dart';
import 'package:gloria_connect/features/guard_exit/screens/all_tab.dart';
import 'package:gloria_connect/features/guard_exit/screens/cab_tab.dart';
import 'package:gloria_connect/features/guard_exit/screens/delivery_tab.dart';
import 'package:gloria_connect/features/guard_exit/screens/guest_tab.dart';
import 'package:gloria_connect/features/guard_exit/screens/service_tab.dart';

class GuardExitScreen extends StatelessWidget {
  const GuardExitScreen({super.key});

  // Define tab data once to avoid repetition
  static const _tabData = [
    {'title': 'All', 'widget': AllTab()},
    {'title': 'Guest', 'widget': GuestTab()},
    {'title': 'Cab', 'widget': CabTab()},
    {'title': 'Delivery', 'widget': DeliveryTab()},
    {'title': 'Service', 'widget': ServiceTab()},
  ];

  // Shared text style for tab labels
  static const _tabTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabData.length,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Main-Gates-Exit',
            style: TextStyle(color: Colors.white70),
          ),
          backgroundColor: Colors.black.withValues(alpha: 0.2),
          bottom: TabBar(
            tabAlignment: TabAlignment.center,
            tabs: _tabData.map((tab) => Tab(child: Text(tab['title'] as String, style: _tabTextStyle))
            ).toList(),
          ),
        ),
        body: TabBarView(
          children: _tabData.map((tab) => tab['widget'] as Widget).toList(),
        ),
      ),
    );
  }
}