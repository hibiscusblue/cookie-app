import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/authentication_bloc/authentication_bloc.dart';
import '../blocs/sign_up_bloc/sign_up_bloc.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 30),

          child: Column(
            children: [
              // ─────────────────────────────
              // NAIM HEADER
              // ─────────────────────────────
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                          ),
                          tooltip: 'Back',
                        ),

                        const SizedBox(width: 22),

                        Image.asset(
                          'assets/blueberry-vanilla.png',
                          width: 42,
                          height: 42,
                        ),

                        const SizedBox(width: 4),

                        const Text(
                          'NAIM',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ─────────────────────────────
              // YOUR NAIM
              // ─────────────────────────────
              const Column(
                children: [
                  Text(
                    'YOUR NAIM',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    'Sign in or create an account to continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ─────────────────────────────
              // AUTHENTICATION CARD
              // ─────────────────────────────
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        const SizedBox(height: 18),

                        // ─────────────────────
                        // SIGN IN / SIGN UP TABS
                        // ─────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TabBar(
                            controller: tabController,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey.shade400,
                            indicatorColor: Colors.black,
                            indicatorWeight: 3,
                            dividerColor: Colors.grey.shade200,

                            labelStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),

                            unselectedLabelStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),

                            tabs: const [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Text('Sign In'),
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Text('Sign Up'),
                              ),
                            ],
                          ),
                        ),

                        // ─────────────────────
                        // TAB CONTENT
                        // ─────────────────────
                        SizedBox(
                          height: 560,
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              const SignInScreen(),

                              BlocProvider<SignUpBloc>(
                                create: (context) => SignUpBloc(
                                  context
                                      .read<AuthenticationBloc>()
                                      .userRepository,
                                ),
                                child: const SignUpScreen(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
