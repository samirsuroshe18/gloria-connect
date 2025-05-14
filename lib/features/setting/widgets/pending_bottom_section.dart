import 'package:flutter/material.dart';

class PendingBottomSection extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback sendMessage;
  final VoidCallback onIsResolved;
  const PendingBottomSection({super.key, required this.messageController, required this.sendMessage, required this.onIsResolved});

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: messageController,
            decoration: InputDecoration(
              hintText: 'Type your message...',
              hintStyle: const TextStyle(color: Colors.white60),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.black.withOpacity(0.2),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white70,
                ),
                onPressed: sendMessage,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onIsResolved,
            icon: const Icon(
              Icons.check_circle_outline,
              color: Colors.white70,
            ),
            label: const Text(
              'Mark as Resolved',
              style: TextStyle(color: Colors.white70),
            ),
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(double.infinity, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.deepPurple.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}
