import 'package:flutter/material.dart';

class InviteVisitorsScreen extends StatefulWidget {
  const InviteVisitorsScreen({super.key});

  @override
  State<InviteVisitorsScreen> createState() => _InviteVisitorsScreenState();
}

class _InviteVisitorsScreenState extends State<InviteVisitorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Who would you like to invite?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildVisitorCard(
                      icon: Icons.person,
                      title: 'Guest',
                      subtitle: 'Pre-approve expected guest entry',
                      color: const Color(0xFF4299E1),
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/contact-screen',
                        arguments: {
                          'profileType': 'guest',
                          'image': 'assets/images/guest/single_guest.png'
                        },
                      ),
                    ),
                    _buildVisitorCard(
                      icon: Icons.delivery_dining,
                      title: 'Delivery',
                      subtitle: 'Pre-approve expected delivery entry',
                      color: const Color(0xFF48BB78),
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/delivery-company-screen',
                      ),
                    ),
                    _buildVisitorCard(
                      icon: Icons.local_taxi,
                      title: 'Cab',
                      subtitle: 'Pre-approve expected cab entry',
                      color: const Color(0xFFED8936),
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/cab-company-screen',
                      ),
                    ),
                    _buildVisitorCard(
                      icon: Icons.build,
                      title: 'Other',
                      subtitle: 'Pre-approve expected services entry',
                      color: const Color(0xFF805AD5),
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/other-services-screen',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVisitorCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}