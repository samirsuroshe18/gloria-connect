import 'package:flutter/material.dart';

class DeliveryHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const DeliveryHeader({super.key, required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white70),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.cancel, size: 20, color: Colors.white70),
          onPressed: onClose,
        ),
      ],
    );
  }
}