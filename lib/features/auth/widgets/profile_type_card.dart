import 'package:flutter/material.dart';

class ProfileTypeCard extends StatelessWidget {
  final bool isSelected;
  final String type;
  final IconData icon;
  final void Function(String) onTap;
  const ProfileTypeCard({super.key, required this.isSelected, required this.type, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.white.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => onTap(type),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 40,
                color: isSelected ? const Color(0xFFFFA000) : const Color(0xFFBDBDBD),
              ),
              const SizedBox(height: 8),
              Text(
                type,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : const Color(0xFFEEEEEE),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
