import 'package:flutter/material.dart';
import 'package:gloria_connect/features/auth/models/get_user_model.dart';
import 'package:gloria_connect/features/setting/widgets/setting_option_tile.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';

class SettingScreen extends StatelessWidget {
  final GetUserModel? data;
  const SettingScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black.withValues(alpha: 0.2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingOptionTile(
              title: 'Raise Complaint',
              onTap: ()=> Navigator.pushNamed(context, '/complaint-screen', arguments: data),
              icon: Icons.report,
            ),
            const SizedBox(height: 10),
            SettingOptionTile(
              title: 'Change Password',
              onTap: ()=> Navigator.pushNamed(context, '/change-password'),
              icon: Icons.password,
            ),
            const SizedBox(height: 10),
            SettingOptionTile(
              title: 'Forgot Password',
              onTap: ()=> Navigator.pushNamed(context, '/forgot-password'),
              icon: Icons.lock_open,
            ),
            const SizedBox(height: 10),
            SettingOptionTile(
              title: 'Privacy Policy',
              onTap: ()=> CustomSnackBar.show(context: context, message: 'Privacy settings coming soon.', type: SnackBarType.info,),
              icon: Icons.lock,
            ),
            const SizedBox(height: 10),
            SettingOptionTile(
              title: 'About',
              onTap: ()=> CustomSnackBar.show(context: context, message: 'About page is under development.', type: SnackBarType.info,),
              icon: Icons.info,
            ),
          ],
        ),
      ),
    );
  }
}
