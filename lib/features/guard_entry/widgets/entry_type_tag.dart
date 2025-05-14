import 'package:flutter/material.dart';

class EntryTypeTag extends StatelessWidget {
  final String text;
  final List<Color> gradientColors;
  final double fontSize;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;

  const EntryTypeTag({
    super.key,
    required this.text,
    this.gradientColors = const [Colors.blue, Colors.lightBlueAccent],
    this.fontSize = 16,
    this.textColor = Colors.white70,
    this.padding = const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: borderRadius,
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
    );
  }
}