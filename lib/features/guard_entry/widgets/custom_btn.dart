import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;
  const CustomBtn({super.key, required this.onTap, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: isLoading
          ? CircularProgressIndicator(
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            backgroundColor: Colors.grey[200],
            strokeWidth: 5.0,)
          : const Text('Ask Residential Approval', style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}
