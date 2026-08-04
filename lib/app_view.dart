import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_application_1/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/auth/views/welcome_screen.dart';
import 'screens/home/views/home_screen.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naim Cookies',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          // ignore: deprecated_member_use
          surface: Colors.grey.shade100,
          onSurface: Colors.black,
          primary: Colors.blue.shade300,
          onPrimary: Colors.white,
        ),
      ),

      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<SignInBloc>(
                  create: (context) => SignInBloc(
                    context.read<AuthenticationBloc>().userRepository,
                  ),
                ),
                BlocProvider(
                  create: (context) => GetCookieBloc(FirebaseCookieRepo()
                )..add(GetCookie()),
                ),
              ],
              child: const HomeScreen(),
            );
          }
          return const WelcomeScreen();
        },
      ),
    );
  }
}
