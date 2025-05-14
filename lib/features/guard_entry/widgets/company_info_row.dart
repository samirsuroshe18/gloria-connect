import 'package:flutter/material.dart';

class CompanyInfoRow extends StatelessWidget {
  final String companyName;
  final String logoAssetPath;
  final double avatarRadius;
  final TextStyle? textStyle;

  const CompanyInfoRow({
    super.key,
    required this.companyName,
    required this.logoAssetPath,
    this.avatarRadius = 13,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundImage: AssetImage(logoAssetPath),
        ),
        const SizedBox(width: 5),
        Text(
          companyName,
          style: textStyle ??
              const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
        ),
      ],
    );
  }
}