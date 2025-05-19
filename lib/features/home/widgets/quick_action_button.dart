import 'package:flutter/material.dart';

class QuickActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String route;
  final BuildContext context;

  const QuickActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(this.context, route);
      },
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white60,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}