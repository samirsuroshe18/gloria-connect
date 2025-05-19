import 'package:flutter/material.dart';

class CircularActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;
  final IconData icon;
  final List<Color> gradientColors;
  final String label;
  final Color shadowColor;

  const CircularActionButton({
    super.key,
    required this.onTap,
    required this.isLoading,
    required this.icon,
    required this.gradientColors,
    required this.label,
    this.shadowColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withValues(alpha: 0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: isLoading
                ? const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Center(
              child: Icon(icon, color: Colors.white, size: 32),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}