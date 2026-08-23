import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/get_cookie_bloc/get_cookie_bloc.dart';
import '../widgets/daily_drop/daily_drop_hero.dart';

class TodaysDropScreen extends StatelessWidget {
  const TodaysDropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: const Text(
          "TODAY'S DROP",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<GetCookieBloc, GetCookieState>(
          builder: (context, state) {
            if (state is GetCookieSuccess) {
              if (state.cookies.isEmpty) {
                return const Center(
                  child: Text('No drop available today.'),
                );
              }

              return SingleChildScrollView(
                child: DailyDropHero(
                  cookies: state.cookies,
                ),
              );
            }

            if (state is GetCookieFailure) {
              return Center(
                child: Text(state.message),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}