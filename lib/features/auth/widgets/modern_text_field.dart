import 'package:flutter/material.dart';

class ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final int? maxLength;
  const ModernTextField({super.key, required this.controller, required this.label, required this.icon, this.keyboardType, this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
                color: Colors.white70
            ),
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              // borderSide: BorderSide.none,
            ),
            filled: true,
            counterText: '',
            fillColor: Colors.black.withValues(alpha: 0.2)
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }
}
