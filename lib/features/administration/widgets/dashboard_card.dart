import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int? badgeCount;
  final VoidCallback onDashboard;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    this.badgeCount,
    required this.onDashboard,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDashboard,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.blue[800],
              ),
              if (badgeCount != null && badgeCount! > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badgeCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.blue[800],
          ),
        ),
      ),
    );
  }
}