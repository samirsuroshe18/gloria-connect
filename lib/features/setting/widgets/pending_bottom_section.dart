import 'package:flutter/material.dart';

class PendingBottomSection extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback sendMessage;
  final VoidCallback onIsResolved;
  final bool isActionLoading;
  final bool isLoading;
  const PendingBottomSection({super.key, required this.messageController, required this.sendMessage, required this.onIsResolved, required this.isActionLoading, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              fillColor: Colors.black.withAlpha(51), // 0.2 * 255 ≈ 51
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: isLoading
                  ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                  ),
                ),
              )
                  : IconButton(
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white70,
                ),
                onPressed: sendMessage,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: isActionLoading ? null : onIsResolved,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              minimumSize: const Size(double.infinity, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.deepPurple.withAlpha(128), // .withValues(alpha: 0.5) is not valid, use withAlpha
            ),
            child: isActionLoading
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            )
                : const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white70),
                SizedBox(width: 8),
                Text(
                  'Mark as Resolved',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
