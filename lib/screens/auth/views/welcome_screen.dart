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

    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
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
          padding: const EdgeInsets.fromLTRB(
            24,
            36,
            24,
            30,
          ),

          child: Column(
            children: [
              // NAIM BRAND
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/blueberry-vanilla.png',
                    width: 48,
                    height: 48,
                  ),

                  const SizedBox(width: 0.1),

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

              const SizedBox(height: 8),

              Text(
                'Your Moment of Bliss',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 44),

              // AUTH CARD
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.08,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    const SizedBox(height: 18),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      child: TabBar(
                        controller: tabController,

                        labelColor: Colors.black,

                        unselectedLabelColor:
                            Colors.grey.shade400,

                        indicatorColor: Colors.black,
                        indicatorWeight: 3,

                        dividerColor:
                            Colors.grey.shade200,

                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),

                        unselectedLabelStyle:
                            const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),

                        tabs: const [
                          Padding(
                            padding:
                                EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            child: Text(
                              'Sign In',
                            ),
                          ),

                          Padding(
                            padding:
                                EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            child: Text(
                              'Sign Up',
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 500,
                      child: TabBarView(
                        controller: tabController,

                        children: [
                          // SignInBloc is already
                          // provided globally in app.dart
                          const SignInScreen(),

                          BlocProvider<SignUpBloc>(
                            create: (context) =>
                                SignUpBloc(
                              context
                                  .read<
                                      AuthenticationBloc>()
                                  .userRepository,
                            ),
                            child:
                                const SignUpScreen(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}