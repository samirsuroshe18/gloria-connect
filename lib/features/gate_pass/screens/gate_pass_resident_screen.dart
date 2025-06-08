import 'package:flutter/material.dart';
import 'package:gloria_connect/features/gate_pass/screens/pass_approve_resident_screen.dart';
import 'package:gloria_connect/features/gate_pass/screens/pass_expired_residents_screen.dart';
import 'package:gloria_connect/features/gate_pass/screens/pass_pending_resident_screen.dart';
import 'package:gloria_connect/features/gate_pass/screens/pass_rejected_residents_screen.dart';

class GatePassResidentScreen extends StatelessWidget {
  const GatePassResidentScreen({super.key});

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black.withValues(alpha: 0.2),
          title: const Text("Gate Pass"),
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: "Approved"),
              Tab(text: "Pending"),
              Tab(text: "Rejected"),
              Tab(text: "Expired"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PassApproveResidentScreen(),
            PassPendingResidentScreen(),
            PassRejectedResidentScreen(),
            PassExpiredResidentScreen(),
          ],
        ),
      ),
    );
  }
}
