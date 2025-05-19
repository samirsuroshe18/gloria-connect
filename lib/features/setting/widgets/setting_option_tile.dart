import 'package:flutter/material.dart';

class SettingOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingOptionTile({super.key, required this.title, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(15)
      ),
      child: ListTile(
        leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blue.withValues(alpha: 0.1),
          ),
          child: Icon(icon, size: 30,),
        ),
        title: Text(title,),
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blue.withValues(alpha: 0.1),
          ),
          child: const Icon(Icons.keyboard_arrow_right, size: 18, color: Colors.grey,),
        ),
        onTap: onTap,
      ),
    );
  }
}
