import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

class AdministrationScreen extends StatefulWidget {
  const AdministrationScreen({super.key});

  @override
  State<AdministrationScreen> createState() => _AdministrationScreenState();
}

class _AdministrationScreenState extends State<AdministrationScreen> {
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            backgroundColor: Colors.black.withOpacity(0.2),
            title: const Text(
              'Administration',
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ),
          SliverPadding(
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
                  return _buildMenuItem(item);
                },
                childCount: menuItems.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildQuickActions(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(AdminMenuItem item) {
    return Material(
      color: Colors.black.withOpacity(0.2),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(context, item.route),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: item.color),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      color: Colors.black.withOpacity(0.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickActionItem(
                  Icons.settings,
                  'Maintainance',
                  Colors.red,
                    (){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("The feature is under development")));
                    }
                ),
                _buildQuickActionItem(
                  Icons.announcement_rounded,
                  'Notice',
                  Colors.blue,
                    (){
                      Navigator.pushNamed(context, '/notice-board-screen');
                    }
                ),
                _buildQuickActionItem(
                  Icons.report,
                  'Complaints',
                  Colors.green,
                    (){
                    Navigator.pushNamed(context, '/complaint-screen', arguments: true);
                    }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(
      IconData icon,
      String label,
      Color color,
      VoidCallback onTap, // Pass onTap function
      ) {
    return InkWell(
      onTap: onTap, // Use the passed function
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
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