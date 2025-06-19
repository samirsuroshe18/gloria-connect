import 'package:flutter/material.dart';
import 'package:gloria_connect/features/administration/widgets/build_menu_item.dart';

class BuildAdminMenuItem extends StatelessWidget {
  const BuildAdminMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    final List<AdminMenuItem> menuItems = [
      AdminMenuItem(
        title: 'Resident Requests',
        icon: Icons.person_add_rounded,
        route: '/resident-approval',
        badgeCount: 0,
        color: Colors.yellow,
        description: 'Review and approve new resident applications',
      ),
      AdminMenuItem(
        title: 'Guard Requests',
        icon: Icons.security_rounded,
        route: '/guard-approval',
        badgeCount: 0,
        color: Colors.orange,
        description: 'Manage security personnel applications',
      ),
      AdminMenuItem(
        title: 'Manage Residents',
        icon: Icons.people_rounded,
        route: '/manage-resident-screen',
        color: Colors.green,
        description: 'View and edit resident information',
      ),
      AdminMenuItem(
        title: 'Manage Guards',
        icon: Icons.security_rounded,
        route: '/all-guard-screen',
        color: Colors.deepOrange,
        description: 'Oversee security staff details',
      ),
      AdminMenuItem(
        title: 'Manage Technician',
        icon: Icons.build_rounded,
        route: '/manage-technician-screen',
        color: Colors.blue,
        description: 'Oversee technician staff details',
      ),
    ];

    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 1.1,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final item = menuItems[index];
            return BuildMenuItem(item: item);
          },
          childCount: menuItems.length,
        ),
      ),
    );
  }
}

class AdminMenuItem {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final int? badgeCount;
  final Color color;

  AdminMenuItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.color,
    required this.description,
    this.badgeCount,
  });
}
