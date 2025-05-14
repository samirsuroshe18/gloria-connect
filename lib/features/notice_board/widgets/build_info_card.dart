import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class BuildInfoCard extends StatelessWidget {
  const BuildInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.3),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white70,),
                SizedBox(width: 8),
                Text(
                  'Create a New Notice',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Share important announcements, updates, or events with your community.',
              style: TextStyle(fontSize: 14, color: Colors.white60),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 14, color: Colors.white60),
                const SizedBox(width: 5),
                Text(
                  'Today, ${DateFormat.yMMMd().format(DateTime.now())}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
