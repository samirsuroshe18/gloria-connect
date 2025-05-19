import 'package:flutter/material.dart';

class CheckInSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final String hintText;
  const CheckInSearchBar({super.key, required this.searchController, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          filled: true, // Enables the fill color
          fillColor: Colors.white.withValues(alpha: 0.2),
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white60),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
