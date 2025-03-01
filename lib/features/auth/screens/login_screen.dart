import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        listener: (context, state){

            if(state is AuthLoginLoading){
                _isLoading = true;
            }

            if(state is AuthLoginSuccess){
              emailController.clear();
              passwordController.clear();
              _isLoading = false;
              if(state.response.phoneNo == null){
                Navigator.pushReplacementNamed(context, '/user-input');
              }else if(state.response.role == 'admin'){
                Navigator.pushReplacementNamed(context, '/admin-home');
              }else if(state.response.role == 'user' && state.response.userType == 'Resident' && state.response.isUserTypeVerified==false){
                Navigator.pushReplacementNamed(context, '/verification-pending-screen');
              }else if(state.response.role == 'user' && state.response.userType == 'Security' && state.response.isUserTypeVerified==false){
                Navigator.pushReplacementNamed(context, '/verification-pending-screen');
              }else if(state.response.role == 'user' && state.response.userType == 'Resident' && state.response.isUserTypeVerified==true){
                Navigator.pushReplacementNamed(context, '/resident-home');
              }else if(state.response.role == 'user' && state.response.userType == 'Security' && state.response.isUserTypeVerified==true) {
                Navigator.pushReplacementNamed(context, '/guard-home');
              }
            }

            if(state is AuthLoginFailure){
              if(state.status==310){
                emailController.clear();
                passwordController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message.toString()),
                  duration: const Duration(seconds: 4),),
                );
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message.toString()),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
              _isLoading = false;
            }

            if(state is AuthGoogleSigningSuccess){
              if(state.response.phoneNo == null){
                Navigator.pushReplacementNamed(context, '/user-input');
              }else if(state.response.role == 'admin'){
                Navigator.pushReplacementNamed(context, '/admin-home');
              }else if(state.response.role == 'user' && state.response.userType == 'Resident' && state.response.isUserTypeVerified==false){
                Navigator.pushReplacementNamed(context, '/verification-pending-screen');
              }else if(state.response.role == 'user' && state.response.userType == 'Security' && state.response.isUserTypeVerified==false){
                Navigator.pushReplacementNamed(context, '/verification-pending-screen');
              }else if(state.response.role == 'user' && state.response.userType == 'Resident' && state.response.isUserTypeVerified==true){
                Navigator.pushReplacementNamed(context, '/resident-home');
              }else if(state.response.role == 'user' && state.response.userType == 'Security' && state.response.isUserTypeVerified==true) {
                Navigator.pushReplacementNamed(context, '/guard-home');
              }
            }

            if(state is AuthGoogleSigningFailure && state.status == 409){
              _showDialogBox();
            }
        },
        builder: (context, state){
          return Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(),
                _inputField(context),
                _forgotPassword(context),
                _signup(context),
                _privacyPolicy(),
              ],
            ),
          );
        },
      )
    );
  }

  Widget _privacyPolicy() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextButton(
        onPressed: () async {
          final Uri url = Uri.parse('https://sites.google.com/view/gloria-connect/home');
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
      ),
    );
  }

  Widget _header() {
    return const Column(
      children: [
        Text(
          "Welcome",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,),
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
        passwordController.text.trim(),));
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
          content: const Text('An account with this email already exists. Would you like to link your Google account to this existing account?'),
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
                }else if (state is AuthGoogleLinkedSuccess) {
                  onPressed(){
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