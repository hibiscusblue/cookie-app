import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../../components/my_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool signInRequired = false;
  bool obscurePassword = true;

  IconData iconPassword = CupertinoIcons.eye_fill;

  String? _errorMsg;

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      context.read<SignInBloc>().add(
            SignInRequired(
              emailController.text.trim(),
              passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          setState(() {
            signInRequired = false;
            _errorMsg = null;
          });
        } else if (state is SignInLoading) {
          setState(() {
            signInRequired = true;
            _errorMsg = null;
          });
        } else if (state is SignInFailure) {
          setState(() {
            signInRequired = false;
            _errorMsg = 'Invalid email or password';
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 28),

              const Text(
                'WELCOME BACK',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Sign in to continue your Naim experience',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 30),

              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  CupertinoIcons.mail_solid,
                  color: Color(0xFF2D160E),
                ),
                errorMsg: _errorMsg,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please fill in this field';
                  }

                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$',
                  ).hasMatch(val)) {
                    return 'Please enter a valid email';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 14),

              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: const Icon(
                  CupertinoIcons.lock_fill,
                  color: Color(0xFF2D160E),
                ),
                errorMsg: _errorMsg,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please fill in this field';
                  }

                  if (val.length < 6) {
                    return 'Password must be at least 6 characters';
                  }

                  return null;
                },
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;

                      iconPassword = obscurePassword
                          ? CupertinoIcons.eye_fill
                          : CupertinoIcons.eye_slash_fill;
                    });
                  },
                  icon: Icon(
                    iconPassword,
                    color: const Color(0xFF2D160E),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              if (!signInRequired)
                SizedBox(
                  height: 54,
                  child: FilledButton(
                    onPressed: _signIn,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                )
              else
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}