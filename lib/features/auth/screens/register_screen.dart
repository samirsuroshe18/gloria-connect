import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../models/user_model.dart';
import '../widgets/auth_btn.dart';
import '../widgets/auth_google_btn.dart';
import '../widgets/text_form_field.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  late final UserModel userModel;

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (BuildContext context, AuthState state) {

          if(state is AuthRegisterLoading){
            _isLoading = true;
          }

          if(state is AuthRegisterSuccess){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.response['message']),
                backgroundColor: Colors.green,
              ),
            );
            userNameController.clear();
            emailController.clear();
            passwordController.clear();
            confirmPasswordController.clear();
            _isLoading = false;
          }

          if(state is AuthRegisterFailure){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message),
                backgroundColor: Colors.redAccent,
              )
            );
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

          if (state is AuthGoogleLinkedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.response['message']),
                backgroundColor: Colors.green,
              ),
            );
          }

        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      ..._header(),
                      ..._form(),
                      ..._footer(),
                      _privacyPolicy(),
                    ],
                  ),
                ),
              ),
            ],
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

  List<Widget> _header() {
    return [
      const SizedBox(height: 80.0),
      const Text(
        textAlign: TextAlign.center,
        "Sign up",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 20),
      Text(
        textAlign: TextAlign.center,
        "Create your account",
        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
      ),
    ];
  }

  List<Widget> _form() {
    return [
      const SizedBox(height: 20),
      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AuthTextField(
              icon: const Icon(Icons.person),
              hintText: 'Username',
              controller: userNameController,
              errorMsg: 'Please enter your username',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            AuthTextField(
              icon: const Icon(Icons.email),
              hintText: 'Email',
              controller: emailController,
              errorMsg: 'Please enter your email',
              obscureText: false,
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
            AuthTextField(
              icon: const Icon(Icons.password),
              hintText: 'Confirm Password',
              controller: confirmPasswordController,
              errorMsg: 'Please confirm your password',
              obscureText: true,
            ),
            const SizedBox(height: 20),
            AuthBtn(
              onPressed: _onSignUpPressed,
              isLoading: _isLoading,
              text: 'Sign up',
            ),
            const SizedBox(height: 10),
            const Center(child: Text("Or")),
            const SizedBox(height: 10),
            AuthGoogleBtn(onPressed: _onGooglePressed),
          ],
        ),
      ),
    ];
  }

  List<Widget> _footer() {
    return [
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Already have an account?"),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              "Sign in",
              style: TextStyle(color: Colors.blue),
            ),
          )
        ],
      ),
    ];
  }

  void _onSignUpPressed() {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password do not match.'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthSignUp(
          userNameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
          confirmPasswordController.text.trim()));
    }
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
