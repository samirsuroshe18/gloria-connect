import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_btn.dart';
import '../widgets/text_form_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthForgotPassLoading) {
          _isLoading = true;
        }
        if (state is AuthForgotPassSuccess) {
          emailController.clear();
          _isLoading = false;
          CustomSnackbar.show(
            context: context,
            message: state.response['message'],
            type: SnackbarType.success,
          );
        }
        if (state is AuthForgotPassFailure) {
          CustomSnackbar.show(
            context: context,
            message: state.message,
            type: SnackbarType.error,
          );
          _isLoading = false;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Forgot Password',
            ),
            backgroundColor: Colors.black.withOpacity(0.2),
          ),
          body: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _text(),
                const SizedBox(height: 20),
                _form(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onForgotPassPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthForgotPassword(
            emailController.text.trim(),
          ));
    }
  }

  _text() {
    return const Text(
      'Enter your email address to reset your password.',
      style: TextStyle(fontSize: 16),
    );
  }

  _form() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AuthTextField(
            icon: const Icon(Icons.email),
            hintText: 'Email',
            controller: emailController,
            errorMsg: 'Please enter your email',
            obscureText: false,
          ),
          const SizedBox(height: 20),
          AuthBtn(
            onPressed: _onForgotPassPressed,
            isLoading: _isLoading,
            text: 'Reset Password',
          ),
        ],
      ),
    );
  }
}
