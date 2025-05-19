import 'package:flutter/material.dart';

class BuildCategory extends StatelessWidget {
  final String? selectedCategory;
  final Map<String, List<String>> categories;
  final void Function(String?)? onChange;
  const BuildCategory({super.key, this.selectedCategory, required this.categories, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintText: 'Select Category',
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.category_outlined, color: Colors.white70),
        ),
        items: categories.keys.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: onChange,
        validator: (value) => value == null ? 'Please select a category' : null,
      ),
    );
  }
}
