import 'package:flutter/material.dart';

class GradientColor extends StatelessWidget {
  final Widget child;
  const GradientColor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xCC125AAA), // Deep Blue
            Color(0xCCA72524), // Rich Red
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: child,
    );
  }
}
