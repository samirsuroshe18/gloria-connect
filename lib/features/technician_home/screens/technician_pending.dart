import 'package:flutter/material.dart';

class TechnicianPending extends StatefulWidget {
  const TechnicianPending({super.key});

  @override
  State<TechnicianPending> createState() => _TechnicianPendingState();
}

class _TechnicianPendingState extends State<TechnicianPending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Pending"),
      ),
    );
  }
}
