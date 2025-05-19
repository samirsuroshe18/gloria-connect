import 'package:flutter/material.dart';

class FlatChip extends StatelessWidget {
  final String flatName;
  final VoidCallback onRemove;

  const FlatChip({
    super.key,
    required this.flatName,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: 0.2),
      margin: const EdgeInsets.only(right: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Text(
              flatName,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: onRemove,
              child: const Icon(Icons.close, size: 20, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
