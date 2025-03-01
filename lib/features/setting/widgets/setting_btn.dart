import 'package:flutter/material.dart';

class SettingBtn extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const SettingBtn({super.key, required this.onPressed, required this.isLoading, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Border radius
        ), // Border color and width
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.blue,
      ),
      child: isLoading
          ? const CircularProgressIndicator()
          : Text(
        text,
        style: const TextStyle(
            fontSize: 20,
            color: Color(0xFFFDE9FD)),
      ),
    );
  }
}
