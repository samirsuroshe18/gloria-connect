import 'package:flutter/material.dart';

class ResolvedBottomSection extends StatelessWidget {
  final VoidCallback onReopen;
  const ResolvedBottomSection({super.key, required this.onReopen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: OutlinedButton.icon(
        onPressed: onReopen,
        icon: const Icon(
          Icons.refresh,
          color: Colors.white70,
        ),
        label: const Text(
          'Reopen Complaint',
          style: TextStyle(color: Colors.white70),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          minimumSize: const Size(double.infinity, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
