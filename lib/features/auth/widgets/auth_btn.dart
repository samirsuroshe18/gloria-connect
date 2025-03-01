import 'package:flutter/material.dart';

class AuthBtn extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const AuthBtn(
      {super.key,
      required this.onPressed,
      required this.isLoading,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Border radius
        ), // Border color and width
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.blue,
      ),
      child: isLoading
          ? CircularProgressIndicator(
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              backgroundColor: Colors.grey[200],
              strokeWidth: 5.0,

            )
          : Text(
              text,
              style: const TextStyle(fontSize: 20, color: Color(0xFFFDE9FD)),
            ),
    );
  }
}
