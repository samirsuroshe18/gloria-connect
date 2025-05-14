import 'package:flutter/material.dart';

class CustomContinueButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const CustomContinueButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor = Colors.blueAccent,
    this.textColor = Colors.white,
    this.fontSize = 18,
    this.borderRadius = 22.0,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}