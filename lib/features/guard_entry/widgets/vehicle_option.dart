import 'package:flutter/material.dart';

class VehicleOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const VehicleOption({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
        ),
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}