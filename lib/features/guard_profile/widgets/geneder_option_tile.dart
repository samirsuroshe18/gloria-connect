import 'package:flutter/material.dart';

class GenderOptionTile extends StatelessWidget {
  final String value;
  final String groupValue;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedBorderColor;

  const GenderOptionTile({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.icon,
    required this.onTap,
    this.selectedColor = Colors.white24,
    this.unselectedBorderColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : unselectedBorderColor,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? selectedColor : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.white70,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontWeight:
                isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}