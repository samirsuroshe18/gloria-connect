import 'package:flutter/material.dart';
import 'package:gloria_connect/features/guard_exit/screens/all_tab.dart';
import 'package:gloria_connect/features/guard_exit/screens/cab_tab.dart';
import 'package:gloria_connect/features/guard_exit/screens/delivery_tab.dart';
import 'package:gloria_connect/features/guard_exit/screens/guest_tab.dart';
import 'package:gloria_connect/features/guard_exit/screens/service_tab.dart';

class GuardExitScreen extends StatefulWidget {
  const GuardExitScreen({super.key});

  @override
  State<GuardExitScreen> createState() => _GuardExitScreenState();
}

class _GuardExitScreenState extends State<GuardExitScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Main-Gates-Exit',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: const Column(
          children: [
            TabBar(
              tabAlignment: TabAlignment.center,
              tabs: [
                Tab(
                    child: Text('All',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15))),
                Tab(
                    child: Text('Guest',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15))),
                Tab(
                    child: Text('Cab',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15))),
                Tab(
                    child: Text('Delivery',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15))),
                Tab(
                    child: Text('Service',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15))),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  AllTab(),
                  GuestTab(),
                  CabTab(),
                  DeliveryTab(),
                  ServiceTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
