import 'package:flutter/material.dart';

class InfoText extends StatelessWidget {
  final String message;
  final EdgeInsetsGeometry padding;
  final Color textColor;
  final double fontSize;

  const InfoText({
    super.key,
    required this.message,
    this.padding = const EdgeInsets.only(top: 8.0, left: 8.0),
    this.textColor = Colors.white70,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        message,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
