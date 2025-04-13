import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/utils/gradient_color.dart';
import 'package:gloria_connect/utils/notification_service.dart';
import 'package:lottie/lottie.dart';

import '../bloc/auth_bloc.dart';
import '../widgets/auth_btn.dart';
import '../widgets/auth_google_btn.dart';
import '../widgets/text_form_field.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    final notificationServices = NotificationController();
    await notificationServices.requestNotificationPermission();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginLoading) {
            _isLoading = true;
          }

          if (state is AuthLoginSuccess) {
            emailController.clear();
            passwordController.clear();
            _isLoading = false;
            if (state.response.phoneNo == null) {
              Navigator.pushReplacementNamed(context, '/user-input');
            } else if (state.response.role == 'admin') {
              Navigator.pushReplacementNamed(context, '/admin-home');
            } else if (state.response.role == 'user' &&
                state.response.userType == 'Resident' &&
                state.response.isUserTypeVerified == false) {
              Navigator.pushReplacementNamed(
                  context, '/verification-pending-screen');
            } else if (state.response.role == 'user' &&
                state.response.userType == 'Security' &&
                state.response.isUserTypeVerified == false) {
              Navigator.pushReplacementNamed(
                  context, '/verification-pending-screen');
            } else if (state.response.role == 'user' &&
                state.response.userType == 'Resident' &&
                state.response.isUserTypeVerified == true) {
              Navigator.pushReplacementNamed(context, '/resident-home');
            } else if (state.response.role == 'user' &&
                state.response.userType == 'Security' &&
                state.response.isUserTypeVerified == true) {
              Navigator.pushReplacementNamed(context, '/guard-home');
            }
          }

          if (state is AuthLoginFailure) {
            if (state.status == 310) {
              emailController.clear();
              passwordController.clear();
              CustomSnackbar.show(
                context: context,
                message: state.message,
                type: SnackbarType.error,
              );
            } else {
              CustomSnackbar.show(
                context: context,
                message: state.message,
                type: SnackbarType.error,
              );
            }
            _isLoading = false;
          }

          if (state is AuthGoogleSigningLoading) {
            _isGoogleLoading = true;
          }

          if (state is AuthGoogleSigningSuccess) {
            _isGoogleLoading = false;
            if (state.response.phoneNo == null) {
              Navigator.pushReplacementNamed(context, '/user-input');
            } else if (state.response.role == 'admin') {
              Navigator.pushReplacementNamed(context, '/admin-home');
            } else if (state.response.role == 'user' &&
                state.response.userType == 'Resident' &&
                state.response.isUserTypeVerified == false) {
              Navigator.pushReplacementNamed(
                  context, '/verification-pending-screen');
            } else if (state.response.role == 'user' &&
                state.response.userType == 'Security' &&
                state.response.isUserTypeVerified == false) {
              Navigator.pushReplacementNamed(
                  context, '/verification-pending-screen');
            } else if (state.response.role == 'user' &&
                state.response.userType == 'Resident' &&
                state.response.isUserTypeVerified == true) {
              Navigator.pushReplacementNamed(context, '/resident-home');
            } else if (state.response.role == 'user' &&
                state.response.userType == 'Security' &&
                state.response.isUserTypeVerified == true) {
              Navigator.pushReplacementNamed(context, '/guard-home');
            }
          }

          if (state is AuthGoogleSigningFailure) {
            _isGoogleLoading = false;
            if (state.status == 409) {
              _showDialogBox();
            }
          }

          if (state is AuthGoogleLinkedSuccess){
            CustomSnackbar.show(context: context, message: state.response['message'], type: SnackbarType.success);
          }

          if (state is AuthGoogleLinkedFailure){
            CustomSnackbar.show(context: context, message: state.message, type: SnackbarType.error);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _header(),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              _inputField(context),
                              const SizedBox(height: 20),
                              _forgotPassword(context),
                              _signup(context),
                              _privacyPolicy(),
                            ],
                          ),
                          if (_isGoogleLoading)
                            Center(
                              child: Lottie.asset(
                                'assets/animations/loader.json',
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _privacyPolicy() {
    return TextButton(
      onPressed: () async {
        final Uri url =
            Uri.parse('https://sites.google.com/view/gloria-connect/home');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      child: const Text(
        'Privacy Policy',
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _header() {
    return const Column(
      children: [
        Text(
          "Welcome",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text("Enter your credentials to login"),
      ],
    );
  }

  Widget _inputField(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthTextField(
            icon: const Icon(Icons.email),
            hintText: 'Email',
            controller: emailController,
            errorMsg: 'Please enter your email',
            obscureText: false,
            inputType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          AuthTextField(
            icon: const Icon(Icons.password),
            hintText: 'Password',
            controller: passwordController,
            errorMsg: 'Please enter your password',
            obscureText: true,
          ),
          const SizedBox(height: 20),
          AuthBtn(
            onPressed: _onSignInPressed,
            isLoading: _isLoading,
            text: 'Sign in',
          ),
          const SizedBox(height: 10),
          const Center(child: Text("Or")),
          const SizedBox(height: 10),
          AuthGoogleBtn(onPressed: _onGooglePressed),
        ],
      ),
    );
  }

  void _onSignInPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthSignIn(
            emailController.text.trim(),
            passwordController.text.trim(),
          ));
    }
  }

  Widget _forgotPassword(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/forgot-password');
      },
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/register');
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Future<void> _onGooglePressed() async {
    context.read<AuthBloc>().add(AuthGoogleSigning());
  }

  void _showDialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Google Account Link'),
          content: const Text(
              'An account with this email already exists. Would you like to link your Google account to this existing account?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthGoogleLinkedLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AuthGoogleLinkedFailure) {
                  return TextButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      // Retry logic can be added here if needed
                    },
                  );
                } else if (state is AuthGoogleLinkedSuccess) {
                  onPressed() {
                    Navigator.of(context).pop();
                  }

                  return TextButton(
                    onPressed: onPressed(),
                    child: const Text('Yes'),
                  );
                } else {
                  return TextButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            AuthGoogleLinked(),
                          );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
