import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color? color;

  const OptionTile({
    required this.icon,
    required this.title,
    this.onTap,
    this.color = Colors.blue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
      onTap: onTap,
    );
  }
}