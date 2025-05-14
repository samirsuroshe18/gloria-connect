import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final VoidCallback onTap;
  const DatePickerField({super.key, required this.controller, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
                color: Colors.white70
            ),
            prefixIcon: const Icon(Icons.calendar_today_rounded),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.black.withOpacity(0.2)
        ),
      ),
    );
  }
}
