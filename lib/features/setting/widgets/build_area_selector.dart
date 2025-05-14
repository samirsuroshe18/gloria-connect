import 'package:flutter/material.dart';

class BuildAreaSelector extends StatelessWidget {
  final String? selectedArea;
  final List<String> areas;
  final void Function(String?)? onChange;
  const BuildAreaSelector({super.key, this.selectedArea, required this.areas, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedArea,
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          hintText: 'Select Area',
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon:
          const Icon(Icons.location_on_outlined, color: Colors.white70),
        ),
        items: areas.map((String area) {
          return DropdownMenuItem<String>(
            value: area,
            child: Text(area),
          );
        }).toList(),
        onChanged: onChange,
        validator: (value) => value == null ? 'Please select an area' : null,
      ),
    );
  }
}
