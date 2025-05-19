import 'package:flutter/material.dart';
import 'package:gloria_connect/features/administration/widgets/quick_action_item.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.black.withValues(alpha: 0.0),
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
                    QuickActionItem(
                      icon: Icons.settings,
                      label: 'Maintainance',
                      color: Colors.red,
                      onTap: (){
                        CustomSnackBar.show(context: context, message: 'The feature is under development', type: SnackBarType.info);
                      }
                    ),
                    QuickActionItem(
                      icon: Icons.announcement_rounded,
                      label: 'Notice',
                      color: Colors.blue,
                      onTap: (){
                        Navigator.pushNamed(context, '/notice-board-screen');
                      }
                    ),
                    QuickActionItem(
                      icon: Icons.report,
                      label: 'Complaints',
                      color: Colors.green,
                      onTap: (){
                        Navigator.pushNamed(context, '/complaint-screen', arguments: true);
                      }
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
}
