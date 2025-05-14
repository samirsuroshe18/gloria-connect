import 'package:flutter/material.dart';

class EntryTypeTag extends StatelessWidget {
  final String entryType;

  const EntryTypeTag({super.key, required this.entryType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        entryType.toUpperCase(),
        style: const TextStyle(color: Colors.white70, fontSize: 16),
      ),
    );
  }
}