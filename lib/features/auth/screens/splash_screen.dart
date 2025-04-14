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
    _checkUserState();
  }

  void _checkUserState() {
    if (mounted) {
      context.read<AuthBloc>().add(AuthGetUser());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthGetUserSuccess) {
            _handleSuccessNavigation(state);
          }
          if (state is AuthGetUserFailure) {
            _handleErrorNavigation(state);
          }
        },
        builder: (context, state) {
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
                Image.asset(
                  'assets/images/branding_img.png',
                  height: 100,
                  color: Colors.white70,
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleSuccessNavigation(AuthGetUserSuccess state) {
    if (!mounted) return;

    if (state.response.phoneNo == null && state.response.isUserTypeVerified == false) {
      Navigator.pushNamedAndRemoveUntil(context, '/user-input', (Route<dynamic> route) => false);
    } else if (state.response.role == 'admin') {
      Navigator.pushNamedAndRemoveUntil(context, '/admin-home', (Route<dynamic> route) => false);
    } else if (state.response.role == 'user' && state.response.userType == 'Resident' && state.response.isUserTypeVerified == false) {
      Navigator.pushNamedAndRemoveUntil(context, '/verification-pending-screen', (Route<dynamic> route) => false);
    } else if (state.response.role == 'user' && state.response.userType == 'Security' && state.response.isUserTypeVerified == false) {
      Navigator.pushNamedAndRemoveUntil(context, '/verification-pending-screen', (Route<dynamic> route) => false);
    } else if (state.response.role == 'user' && state.response.userType == 'Resident' && state.response.isUserTypeVerified == true) {
      Navigator.pushNamedAndRemoveUntil(context, '/resident-home', (Route<dynamic> route) => false);
    } else if (state.response.role == 'user' &&
        state.response.userType == 'Security' &&
        state.response.isUserTypeVerified == true &&
        state.response.isOnDuty == false) {
      Navigator.pushReplacementNamed(context, '/duty-login');
    } else if (state.response.role == 'user' && state.response.userType == 'Security' && state.response.isUserTypeVerified == true) {
      Navigator.pushNamedAndRemoveUntil(context, '/guard-home', (Route<dynamic> route) => false);
    }
  }

  void _handleErrorNavigation(AuthGetUserFailure state) async {
    // Store context in variable to avoid issues with async gaps
    final currentContext = context;
    
    // Function to safely navigate if still mounted
    void safeNavigate(String route, {Object? arguments, bool Function(Route<dynamic>)? predicate}) {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          currentContext, 
          route, 
          predicate ?? (route) => false,
          arguments: arguments
        );
      }
    }

    // Define onRetryCallback that's safe to use
    onRetryCallback() {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          currentContext,
          '/',
          (route) => false
        );
      }
    }

    switch (state.errorType) {
      case AuthErrorType.unauthorized:
        safeNavigate('/login');
        break;

      case AuthErrorType.noInternet:
        final token = await getAccessToken();
        if (!mounted) return; // Check mounted after await
        
        if (token != null) {
          safeNavigate(
            '/error',
            arguments: {
              'errorType': 'noInternet',
              'message': 'No internet connection. Please check your connectivity.',
              'showLoginOption': false,
              'showRetryOption': true,
              'onRetry': onRetryCallback,
            }
          );
        } else {
          safeNavigate('/login');
        }
        break;

      case AuthErrorType.serverError:
        safeNavigate(
          '/error',
          arguments: {
            'errorType': 'serverError',
            'message': 'Our servers are currently experiencing issues. Please try again later.',
            'showLoginOption': true,
            'showRetryOption': true,
            'onRetry': onRetryCallback,
          }
        );
        break;

      case AuthErrorType.unexpectedError:
      default:
        final token = await getAccessToken();
        if (!mounted) return; // Check mounted after await
        
        if (token != null) {
          safeNavigate(
            '/error',
            arguments: {
              'errorType': 'unexpectedError',
              'message': 'Something went wrong. ${state.message}',
              'showLoginOption': true,
              'showRetryOption': true,
              'onRetry': onRetryCallback,
            }
          );
        } else {
          safeNavigate('/login');
        }
        break;
    }
  }

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}