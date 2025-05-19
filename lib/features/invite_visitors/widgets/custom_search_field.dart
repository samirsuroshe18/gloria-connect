import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double top;

  const CustomSearchField({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.top = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, bottom: 8, right: 8, top: top),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 16, color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white60),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(13),
          fillColor: Colors.transparent,
        ),
      ),
    );
  }
}