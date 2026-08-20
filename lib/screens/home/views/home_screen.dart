import 'dart:async';
import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/cookie_image.dart';
import 'package:flutter_application_1/screens/home/blocs/get_cookie_bloc/get_cookie_bloc.dart';
import 'package:flutter_application_1/screens/home/views/details_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';
import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/home/widgets/daily_drop/daily_drop_hero.dart';
import 'package:flutter_application_1/screens/home/widgets/collection/cookie_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      endDrawer: const NaimDrawer(),
      appBar: const NaimAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<GetCookieBloc, GetCookieState>(
          builder: (context, state) {
            return switch (state) {
              GetCookieSuccess() when state.cookies.isEmpty => const Center(
                child: Text('No cookies have been added yet.'),
              ),

              GetCookieSuccess() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DAILY DROP HERO
                  DailyDropHero(cookies: state.cookies),

                  const SizedBox(height: 24),

                  // COLLECTION TITLE
                  const Text(
                    'THE COLLECTION',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Our most-loved cookies',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 14),

                  // EXISTING COOKIE GRID
                  Expanded(
                    child: GridView.builder(
                      itemCount: state.cookies.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.68,
                          ),
                      itemBuilder: (context, index) {
                        return CookieCard(cookie: state.cookies[index]);
                      },
                    ),
                  ),
                ],
              ),

              GetCookieFailure() => _FailureView(message: state.message),

              _ => const Center(child: CircularProgressIndicator()),
            };
          },
        ),
      ),
    );
  }
}


class _FailureView extends StatelessWidget {
  const _FailureView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                context.read<GetCookieBloc>().add(GetCookie());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NaimPage extends StatelessWidget {
  const _NaimPage({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),

            const SizedBox(height: 6),

            Text(
              subtitle,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 40),

            const Center(
              child: Text(
                'Coming soon 🍪',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
