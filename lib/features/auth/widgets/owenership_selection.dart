import 'package:flutter/material.dart';

class OwenershipSelection extends StatelessWidget {
  final String? ownershipStatus;
  final void Function(bool, String) onSelected;
  const OwenershipSelection({super.key,this.ownershipStatus, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> ownershipItems = ['Owner', 'Tenant'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ownershipItems.map((status) {
        bool isSelected = ownershipStatus == status;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ChoiceChip(
              label: Text(
                status,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) => onSelected(selected, status),
              selectedColor: Colors.white.withValues(alpha: 0.15), // subtle white overlay for contrast
              backgroundColor: Colors.white.withValues(alpha: 0.05), // more subtle, blends with gradient
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected ? Colors.white : Colors.white30,
                  width: 1.2,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        );
      }).toList(),
    );
  }
}
