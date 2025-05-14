import 'package:flutter/material.dart';

class ApartmentListRow extends StatelessWidget {
  final List<Map<String, String>> apartments;
  final IconData icon;
  final Color iconColor;
  final TextStyle? textStyle;
  final double iconSize;
  final EdgeInsets iconPadding;
  final double spacing;

  const ApartmentListRow({
    super.key,
    required this.apartments,
    this.icon = Icons.home,
    this.iconColor = Colors.white70,
    this.textStyle,
    this.iconSize = 20,
    this.iconPadding = const EdgeInsets.all(5.0),
    this.spacing = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: iconPadding,
          child: Icon(icon, size: iconSize, color: iconColor),
        ),
        SizedBox(width: spacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: apartments
                .map((e) => Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                e['apartment'] ?? '',
                style: textStyle ??
                    const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
              ),
            ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
