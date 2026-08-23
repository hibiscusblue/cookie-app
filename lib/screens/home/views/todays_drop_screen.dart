import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';

import '../blocs/get_cookie_bloc/get_cookie_bloc.dart';
import '../widgets/daily_drop/daily_drop_hero.dart';

class TodaysDropScreen extends StatelessWidget {
  const TodaysDropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => context.read<GetCookieBloc>(),
      child: const _TodaysDropView(),
    );
  }
}

class _TodaysDropView extends StatelessWidget {
  const _TodaysDropView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),
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