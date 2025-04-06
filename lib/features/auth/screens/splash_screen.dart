import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthGetUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state){
          if(state is AuthGetUserSuccess){
            if(state.response.phoneNo == null && state.response.isUserTypeVerified==false){
              Navigator.pushNamedAndRemoveUntil(context, '/user-input', (Route<dynamic> route) => false);
            }else if(state.response.role=='admin'){
              Navigator.pushNamedAndRemoveUntil(context, '/admin-home', (Route<dynamic> route) => false);
            }else if(state.response.role == 'user' && state.response.userType == 'Resident' && state.response.isUserTypeVerified==false){
              Navigator.pushNamedAndRemoveUntil(context, '/verification-pending-screen', (Route<dynamic> route) => false);
            }else if(state.response.role == 'user' && state.response.userType == 'Security' && state.response.isUserTypeVerified==false){
              Navigator.pushNamedAndRemoveUntil(context, '/verification-pending-screen', (Route<dynamic> route) => false);
            }else if(state.response.role == 'user' && state.response.userType == 'Resident' && state.response.isUserTypeVerified==true){
              Navigator.pushNamedAndRemoveUntil(context, '/resident-home', (Route<dynamic> route) => false);
            }else if(state.response.role == 'user' && state.response.userType == 'Security' && state.response.isUserTypeVerified==true) {
              Navigator.pushNamedAndRemoveUntil(context, '/guard-home', (Route<dynamic> route) => false);
            }
          }
          if(state is AuthGetUserFailure){
            Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
          }
        },
        builder: (context, state){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                  'assets/app_logo/splash_screen_logo.png',
                  height: 300,
                ),
                const Spacer(),
                // The text below the logo
                Image.asset(
                  'assets/images/branding_img.png',
                  height: 100,
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      )
    );
  }

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}
