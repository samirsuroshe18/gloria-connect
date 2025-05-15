import 'package:flutter/material.dart';

import '../../auth/models/get_user_model.dart';

class BuildActionList extends StatelessWidget {
  final GetUserModel? data;
  final VoidCallback logoutUser;
  final VoidCallback onAddGatePass;
  const BuildActionList({super.key, this.data, required this.logoutUser, required this.onAddGatePass});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {
        'title': 'View Checkout History',
        'icon': Icons.history,
        'color': Colors.white70,
        'route': '/checkout-history-screen',
      },
      {
        'title': 'View Gate Pass',
        'icon': Icons.visibility,
        'color': Colors.white70,
        'route': '/gate-pass-list-screen',
      },
      {
        'title': 'Add Gate Pass',
        'icon': Icons.add_circle,
        'color': Colors.white70,
        'onTap': onAddGatePass,
      },
      {
        'title': 'Settings',
        'icon': Icons.settings,
        'color': Colors.white70,
        'route': '/setting-screen',
        'arguments': data,
      },
      {
        'title': 'Logout',
        'icon': Icons.logout,
        'color': Colors.redAccent,
        'onTap': logoutUser,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: actions.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final action = actions[index];
          return ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: action['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                action['icon'],
                color: action['color'],
              ),
            ),
            title: Text(
              action['title'],
              style: TextStyle(
                color: action['title'] == 'Logout' ? Colors.redAccent : Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.grey,
            ),
            onTap: action['onTap'] ??
                    () => Navigator.pushNamed(context, action['route'], arguments: action['arguments']),
          );
        },
      ),
    );
  }
}
