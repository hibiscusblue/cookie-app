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

  bool obscurePassword = true;
  bool signUpRequired = false;

  IconData iconPassword = CupertinoIcons.eye_fill;

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
    super.dispose();
  }

  void _updatePasswordRequirements(String value) {
    setState(() {
      containsUpperCase = value.contains(RegExp(r'[A-Z]'));
      containsLowerCase = value.contains(RegExp(r'[a-z]'));
      containsNumber = value.contains(RegExp(r'[0-9]'));
      containsSpecialChar =
          value.contains(RegExp(r'[!@#$%^&*()~_+{}|:"<>?]'));
      containsMinLength = value.length >= 8;
    });
  }

  void _signUp() {
    if (_formKey.currentState?.validate() ?? false) {
      final myUser = MyUser(
        userId: '',
        email: emailController.text.trim(),
        name: nameController.text.trim(),
        hasActiveCart: false,
      );

      context.read<SignUpBloc>().add(
            SignUpRequired(
              myUser,
              passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 28),

              const Text(
                'JOIN NAIM',
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
                'Create your account and discover your favorites',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 28),

              // EMAIL
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

              const SizedBox(height: 14),

              // PASSWORD
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
                  icon: Icon(
                    iconPassword,
                    color: const Color(0xFF2D160E),
                  ),
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

              const SizedBox(height: 14),

              // PASSWORD REQUIREMENTS
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PASSWORD MUST INCLUDE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _PasswordRequirement(
                      text: '1 uppercase letter',
                      completed: containsUpperCase,
                    ),

                    _PasswordRequirement(
                      text: '1 lowercase letter',
                      completed: containsLowerCase,
                    ),

                    _PasswordRequirement(
                      text: '1 number',
                      completed: containsNumber,
                    ),

                    _PasswordRequirement(
                      text: '1 special character',
                      completed: containsSpecialChar,
                    ),

                    _PasswordRequirement(
                      text: '8 minimum characters',
                      completed: containsMinLength,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // NAME
              MyTextField(
                controller: nameController,
                hintText: 'Name',
                obscureText: false,
                keyboardType: TextInputType.name,
                prefixIcon: const Icon(
                  CupertinoIcons.person_fill,
                  color: Color(0xFF2D160E),
                ),
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

              const SizedBox(height: 24),

              // SIGN UP BUTTON
              if (!signUpRequired)
                SizedBox(
                  height: 54,
                  child: FilledButton(
                    onPressed: _signUp,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'CREATE ACCOUNT',
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

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordRequirement extends StatelessWidget {
  const _PasswordRequirement({
    required this.text,
    required this.completed,
  });

  final String text;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3,
      ),
      child: Row(
        children: [
          Icon(
            completed
                ? CupertinoIcons.check_mark_circled_solid
                : CupertinoIcons.circle,
            size: 15,
            color: completed
                ? const Color(0xFF2D160E)
                : Colors.grey.shade400,
          ),

          const SizedBox(width: 8),

          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight:
                  completed ? FontWeight.w700 : FontWeight.w500,
              color: completed
                  ? const Color(0xFF2D160E)
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}