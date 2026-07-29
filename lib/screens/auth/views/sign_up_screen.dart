import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import '../../../components/my_text_field.dart';
import '../blocs/sign_up_bloc/sign_up_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  bool signUpRequired = false;
  String? _errorMsg;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool containsMinLength = false;

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  void _updatePasswordRequirements(String value) {
    setState(() {
      containsUpperCase = value.contains(RegExp(r'[A-Z]'));
      containsLowerCase = value.contains(RegExp(r'[a-z]'));
      containsNumber = value.contains(RegExp(r'[0-9]'));
      containsSpecialChar = value.contains(RegExp(r'[!@#$%^&*()~_+{}|:"<>?]'));
      containsMinLength = value.length >= 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    final requirementColor = Theme.of(context).colorScheme.onSurface;

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
            _errorMsg = null;
          });
        } else if (state is SignUpLoading) {
          setState(() {
            signUpRequired = true;
            _errorMsg = null;
          });
        } else if (state is SignUpFailure) {
          setState(() {
            signUpRequired = false;
            _errorMsg = 'Unable to create your account';
          });
        }
      },
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(CupertinoIcons.mail_solid),
                  errorMsg: _errorMsg,
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    if (email.isEmpty) {
                      return 'Please fill in this field';
                    }
                    if (!RegExp(
                      r'^[\w.-]+@([\w-]+\.)+[\w-]{2,}$',
                    ).hasMatch(email)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: const Icon(CupertinoIcons.lock_fill),
                  onChanged: _updatePasswordRequirements,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                        iconPassword = obscurePassword
                            ? CupertinoIcons.eye_fill
                            : CupertinoIcons.eye_slash_fill;
                      });
                    },
                    icon: Icon(iconPassword),
                  ),
                  validator: (value) {
                    final password = value ?? '';
                    if (password.isEmpty) {
                      return 'Please fill in this field';
                    }
                    if (password.length < 8 ||
                        !password.contains(RegExp(r'[A-Z]')) ||
                        !password.contains(RegExp(r'[a-z]')) ||
                        !password.contains(RegExp(r'[0-9]')) ||
                        !password.contains(
                          RegExp(r'[!@#$%^&*()~_+{}|:"<>?]'),
                        )) {
                      return 'Please meet all password requirements';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1 uppercase',
                        style: TextStyle(
                          color: containsUpperCase
                              ? Colors.green
                              : requirementColor,
                        ),
                      ),
                      Text(
                        '1 lowercase',
                        style: TextStyle(
                          color: containsLowerCase
                              ? Colors.green
                              : requirementColor,
                        ),
                      ),
                      Text(
                        '1 number',
                        style: TextStyle(
                          color: containsNumber
                              ? Colors.green
                              : requirementColor,
                        ),
                      ),
                      Text(
                        '1 special character',
                        style: TextStyle(
                          color: containsSpecialChar
                              ? Colors.green
                              : requirementColor,
                        ),
                      ),
                      Text(
                        '8 minimum characters',
                        style: TextStyle(
                          color: containsMinLength
                              ? Colors.green
                              : requirementColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: MyTextField(
                  controller: nameController,
                  hintText: 'Name',
                  obscureText: false,
                  keyboardType: TextInputType.name,
                  prefixIcon: const Icon(CupertinoIcons.person_fill),
                  validator: (value) {
                    final name = value?.trim() ?? '';
                    if (name.isEmpty) {
                      return 'Please fill in this field';
                    }
                    if (name.length > 30) {
                      return 'Name too long';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 30),
              if (!signUpRequired)
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final myUser = MyUser(
                          userId: '',
                          email: emailController.text.trim(),
                          name: nameController.text.trim(),
                          hasActiveCart: false,
                        );

                        context.read<SignUpBloc>().add(
                          SignUpRequired(myUser, passwordController.text),
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      elevation: 3,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 5,
                      ),
                      child: Text(
                        'Sign Up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              else
                const CircularProgressIndicator(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
