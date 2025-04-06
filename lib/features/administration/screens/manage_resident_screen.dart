import 'package:flutter/material.dart';

class ManageResidentScreen extends StatelessWidget {
  const ManageResidentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Residents', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black.withOpacity(0.2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(20))
              ),
              child: ListTile(
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  child: const Icon(Icons.home, size: 30,),
                ),
                title: const Text('Residents',),
                trailing: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  child: const Icon(Icons.keyboard_arrow_right, size: 18, color: Colors.grey,),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/all-resident-screen');
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(Radius.circular(20))
              ),
              child: ListTile(
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  child: const Icon(Icons.security, size: 30,),
                ),
                title: const Text('All Admin',),
                trailing: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  child: const Icon(Icons.keyboard_arrow_right, size: 18, color: Colors.grey,),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/all-admin-screen');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
