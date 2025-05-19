import 'package:flutter/material.dart';

class BuildSubCategory extends StatelessWidget {
  final String? selectedSubCategory;
  final Map<String, List<String>> categories;
  final String? selectedCategory;
  final void Function(String?)? onChange;
  const BuildSubCategory({super.key, this.selectedSubCategory, required this.categories, this.selectedCategory, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonFormField(
          isExpanded: true,  // Forces the dropdown to take the full width
          value: selectedSubCategory,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.transparent,
            hintText: 'Select Sub-Category',
            hintStyle: const TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.subdirectory_arrow_right,
                color: Colors.white70),
          ),
          items: categories[selectedCategory]!.map((String subCategory) {
            return DropdownMenuItem(
              value: subCategory,
              child: Text(subCategory, overflow: TextOverflow.ellipsis), // Avoids text overflow
            );
          }).toList(),
          onChanged: onChange,
          validator: (value) => value == null ? 'Please select a sub-category' : null,
        ),
      ),
    );
  }
}
