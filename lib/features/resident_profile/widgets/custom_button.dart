import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String btnText;
  const CustomButton({super.key, required this.isLoading, required this.onPressed, required this.btnText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Center(
        child: isLoading
            ? CircularProgressIndicator(
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          backgroundColor: Colors.grey[200],
          strokeWidth: 5.0,)
            : Text(btnText, style: const TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
