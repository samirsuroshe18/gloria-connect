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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Current'),
                Tab(text: 'Expected'),
                Tab(text: 'Past'),
                Tab(text: 'Denied'),
              ],
            ),
            Expanded(
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
