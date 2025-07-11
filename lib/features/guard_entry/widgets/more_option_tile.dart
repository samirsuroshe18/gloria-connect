import 'package:flutter/material.dart';

class MoreOptionsTile extends StatelessWidget {
  final VoidCallback onTap;
  const MoreOptionsTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withValues(alpha: 0.2),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.more_horiz, size: 40, color: Colors.white70),
            SizedBox(height: 5),
            Text('More', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}