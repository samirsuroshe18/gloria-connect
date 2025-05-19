import 'package:flutter/material.dart';

class CompanyTile extends StatelessWidget {
  final String companyName;
  final String logo;
  final bool isSelected;
  final VoidCallback onTap;

  const CompanyTile({
    super.key,
    required this.companyName,
    required this.logo,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(logo),
                ),
                const SizedBox(height: 5),
                Text(companyName, style: const TextStyle(fontSize: 14, color: Colors.white70)),
              ],
            ),
            if (isSelected)
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.check_circle, color: Colors.white70, size: 24),
              ),
          ],
        ),
      ),
    );
  }
}