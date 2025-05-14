import 'package:flutter/material.dart';

class ModernDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String label;
  final Function(String?) onChanged;
  final IconData icon;
  const ModernDropdown({super.key, this.value, required this.items, required this.label, required this.onChanged, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white70),
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              // borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.black.withOpacity(0.2)
        ),
      ),
    );
  }
}
