import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final void Function(String?)? onChanged;

  const CustomDropdownFormField({
    super.key,
    required this.value,
    required this.items,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.white60,
          fontWeight: FontWeight.w500,
        ),
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: Colors.white70),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70, width: 1.5),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
      ),
      value: value,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
      items: items.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}