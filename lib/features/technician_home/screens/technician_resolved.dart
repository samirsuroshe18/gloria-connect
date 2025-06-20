import 'package:flutter/material.dart';

class TechnicianResolved extends StatefulWidget {
  const TechnicianResolved({super.key});

  @override
  State<TechnicianResolved> createState() => _TechnicianResolvedState();
}

class _TechnicianResolvedState extends State<TechnicianResolved> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Resolved"),
      ),
    );
  }
}
