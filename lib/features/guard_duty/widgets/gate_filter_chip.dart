import 'package:flutter/material.dart';

class GateFilterChip extends StatelessWidget {
  final String label;
  final String value;
  final String selectedValue;
  final void Function(String newValue) onSelected;

  const GateFilterChip({
    super.key,
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selectedValue == value,
      onSelected: (selected) {
        onSelected(selected ? value : '');
      },
    );
  }
}
