import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_application_1/screens/home/blocs/get_cookie_bloc/get_cookie_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/auth/views/welcome_screen.dart';
import 'screens/home/views/home_screen.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
      listener: (context, state) {
        if (state.status != AuthenticationStatus.authenticated) {
          _navigatorKey.currentState?.popUntil((route) => route.isFirst);
        }
      },
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Naim Cookies',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          colorScheme: ColorScheme.light(
            surface: Colors.grey.shade100,
            onSurface: Colors.black,
            primary: Colors.black,
            onPrimary: Colors.white,
          ),
        ),

        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<GetCookieBloc>(
                    create: (context) =>
                        GetCookieBloc(FirebaseCookieRepo())..add(GetCookie()),
                  ),
                ],
                child: const HomeScreen(),
              );
            }

            return const WelcomeScreen();
          },
        ),
      ),
    );
  }
}
