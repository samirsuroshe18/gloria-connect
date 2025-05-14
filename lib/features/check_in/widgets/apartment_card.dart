import 'package:flutter/material.dart';

class ApartmentCard extends StatelessWidget {
  final String flat;
  final String selected;
  final bool isSelected;
  final void Function(String) toggleFlatSelection;
  const ApartmentCard({super.key, required this.toggleFlatSelection, required this.selected, required this.flat, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () => toggleFlatSelection(selected),
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Icon(Icons.home, color: Colors.white70),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  flat,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ),
              Checkbox(
                value: isSelected,
                onChanged: (value) {
                  toggleFlatSelection(selected);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
