import 'package:flutter/material.dart';
import 'package:gloria_connect/features/auth/models/get_user_model.dart';


class SettingScreen extends StatelessWidget {
  final GetUserModel? data;
  const SettingScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white),),
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
                borderRadius: BorderRadius.circular(15)
              ),
              child: ListTile(
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  child: const Icon(Icons.report, size: 30,),
                ),
                title: const Text('Raise Complaint',),
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
                  Navigator.pushNamed(context, '/complaint-screen', arguments: data);
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: ListTile(
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  child: const Icon(Icons.password, size: 30,),
                ),
                title: const Text('Change Password',),
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
                  Navigator.pushNamed(context, '/change-password');
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: ListTile(
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  child: const Icon(Icons.lock_open, size: 30,),
                ),
                title: const Text('Forgot Password',),
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
                  Navigator.pushNamed(context, '/forgot-password');
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: ListTile(
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  child: const Icon(Icons.lock, size: 30,),
                ),
                title: const Text('Privacy Setting',),
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
                  const snackBar = SnackBar(
                    content: Text('Privacy settings coming soon.'),
                    duration: Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: ListTile(
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  child: const Icon(Icons.info, size: 30,),
                ),
                title: const Text('About',),
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
                  const snackBar = SnackBar(
                    content: Text('About page is under development.'),
                    duration: Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
