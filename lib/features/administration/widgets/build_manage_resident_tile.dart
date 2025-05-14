import 'package:flutter/material.dart';

class BuildManageResidentTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const BuildManageResidentTile({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: ListTile(
        leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blue.withOpacity(0.1),
          ),
          child: const Icon(
            Icons.home,
            size: 30,
          ),
        ),
        title: Text(
          title,
        ),
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blue.withOpacity(0.1),
          ),
          child: const Icon(
            Icons.keyboard_arrow_right,
            size: 18,
            color: Colors.grey,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
