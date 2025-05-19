import 'package:flutter/material.dart';
import 'package:gloria_connect/features/my_visitors/screens/current_visitors_screen.dart';
import 'package:gloria_connect/features/my_visitors/screens/denied_visitors_screen.dart';
import 'package:gloria_connect/features/my_visitors/screens/expected_visitors_screen.dart';
import 'package:gloria_connect/features/my_visitors/screens/past_visitors_screen.dart';

class MyVisitorsScreen extends StatefulWidget {
  const MyVisitorsScreen({super.key});

  @override
  State<MyVisitorsScreen> createState() => _MyVisitorsScreenState();
}

class _MyVisitorsScreenState extends State<MyVisitorsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black.withValues(alpha: 0.2),
          title: const Text(
            'My Visitors',
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.black.withValues(alpha: 0.2),
              child: const TabBar(
                labelColor: Colors.white70, // Text color for selected tab
                unselectedLabelColor: Colors.white60, // Text color for unselected tabs
                indicatorColor: Colors.blue, // Indicator color
                tabs: [
                  Tab(text: 'Current'),
                  Tab(text: 'Expected'),
                  Tab(text: 'Past'),
                  Tab(text: 'Denied'),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  CurrentVisitorsScreen(),
                  ExpectedVisitorsScreen(),
                  PastVisitorsScreen(),
                  DeniedVisitorsScreen()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
