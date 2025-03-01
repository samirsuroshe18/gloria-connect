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
          color: isSelected ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),  // Main shadow color
              offset: const Offset(4, 4),                 // Shadow direction
              blurRadius: 3,                       // Blurriness
              spreadRadius: 1,                      // Spread of the shadow
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8), // Highlight to give 3D effect
              offset: const Offset(-4, -4),               // Inverse shadow for depth
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
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
                Text(companyName, style: const TextStyle(fontSize: 14)),
              ],
            ),
            if (isSelected)
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.check_circle, color: Colors.green, size: 24),
              ),
          ],
        ),
      ),
    );
  }
}