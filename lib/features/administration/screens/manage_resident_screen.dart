import 'package:flutter/material.dart';
import 'package:gloria_connect/features/administration/widgets/build_manage_resident_tile.dart';

class ManageResidentScreen extends StatelessWidget {
  const ManageResidentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Residents',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildManageResidentTile(
              title: 'Resident',
              onTap: () {
                Navigator.pushNamed(context, '/all-resident-screen');
              },
            ),
            const SizedBox(height: 10),
            BuildManageResidentTile(
              title: 'All Admin',
              onTap: () {
                Navigator.pushNamed(context, '/all-admin-screen');
              },
            ),
          ],
        ),
      ),
    );
  }
}
