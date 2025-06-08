import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/check_in/bloc/check_in_bloc.dart';
import 'package:gloria_connect/features/guard_profile/screens/gate_pass_expired_screen.dart';
import 'package:gloria_connect/features/guard_profile/screens/gate_pass_list_screen.dart';
import 'package:gloria_connect/features/guard_profile/screens/gate_pass_pending_screen.dart';

class GatePassGuardScreen extends StatelessWidget {
  const GatePassGuardScreen({super.key});

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black.withValues(alpha: 0.2),
          title: const Text("Gate Pass"),
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: "Approved"),
              Tab(text: "Pending"),
              Tab(text: "Expired"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            GatePassListScreen(),
            GatePassPendingScreen(),
            GatePassExpiredScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'resolvedFABC',
          onPressed: () => _addGatePass(context),
          backgroundColor: Colors.blue,
          icon: const Icon(Icons.add, color: Colors.white70),
          label: const Text(
            'Add Pass',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }

  void _addGatePass(BuildContext context) {
    context.read<CheckInBloc>().add(ClearFlat());
    Navigator.pushNamed(context, '/add-service-screen');
  }
}
