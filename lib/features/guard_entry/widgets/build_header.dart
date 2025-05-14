import 'package:flutter/material.dart';

class BuildHeader extends StatelessWidget {
  final String title;
  final VoidCallback onEditTap;

  const BuildHeader({
    super.key,
    required this.title,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.edit,
            size: 20,
            color: Colors.white70,
          ),
          onPressed: onEditTap,
        ),
      ],
    );
  }
}