import 'package:flutter/material.dart';

class GuestSelector extends StatelessWidget {
  final int guestCount;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final String Function() guestTextBuilder;

  const GuestSelector({
    super.key,
    required this.guestCount,
    required this.onIncrement,
    required this.onDecrement,
    required this.guestTextBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ADD ACCOMPANYING GUESTS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                  ),
                  onPressed: guestCount > 0 ? onDecrement : null,
                ),
                Text(
                  guestCount.toString(),
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.green,
                  ),
                  onPressed: onIncrement,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white.withOpacity(0.2),
          ),
          child: Text(
            guestTextBuilder(),
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ),
      ],
    );
  }
}