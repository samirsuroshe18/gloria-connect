import 'package:flutter/material.dart';

class EntryActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String label;
  final Color backgroundColor;

  const EntryActionButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: backgroundColor,
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            backgroundColor: Colors.grey[200],
            strokeWidth: 5.0,
          )
              : Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}