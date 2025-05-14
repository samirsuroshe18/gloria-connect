import 'package:flutter/material.dart';

class CustomPreApproveCard extends StatelessWidget {
  final String name;
  final String image;
  final VoidCallback onTap;

  const CustomPreApproveCard({
    super.key,
    required this.name,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(image),
            radius: 25,
          ),
          title: Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.white70),
          onTap: onTap,
        ),
      ),
    );
  }
}
