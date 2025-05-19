import 'package:flutter/material.dart';

class BuildDescription extends StatelessWidget {
  final TextEditingController descriptionController;
  const BuildDescription({super.key, required this.descriptionController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: descriptionController,
        maxLines: 4,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintText: 'Describe your complaint in detail...',
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 80),
            child: Icon(Icons.description_outlined, color: Colors.white70),
          ),
        ),
        validator: (value) =>
        value?.isEmpty == true ? 'Please enter a description' : null,
      ),
    );
  }
}
