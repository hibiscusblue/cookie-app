import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/favorites.dart';
import 'package:flutter_application_1/screens/home/blocs/get_cookie_bloc/get_cookie_bloc.dart';
import 'package:flutter_application_1/screens/home/widgets/collection/cookie_card.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetCookieBloc(
        FirebaseCookieRepo(),
      )..add(GetCookie()),
      child: const _FavoritesView(),
    );
  }
}

class _FavoritesView extends StatelessWidget {
  const _FavoritesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),

      body: BlocBuilder<GetCookieBloc, GetCookieState>(
        builder: (context, state) {
          if (state is GetCookieFailure) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          if (state is! GetCookieSuccess) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }

          return FutureBuilder<void>(
            future: Favorites.load(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }

              return ValueListenableBuilder<int>(
                valueListenable: Favorites.changes,
                builder: (context, _, _) {
                  final favoriteCookies = state.cookies
                      .where(
                        (cookie) => Favorites.contains(cookie),
                      )
                      .toList();

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'FAVORITES',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'The ones you couldn\'t forget',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Expanded(
                          child: favoriteCookies.isEmpty
                              ? const _EmptyFavorites()
                              : GridView.builder(
                                  itemCount: favoriteCookies.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.68,
                                  ),
                                  itemBuilder: (context, index) {
                                    return CookieCard(
                                      cookie: favoriteCookies[index],
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.heart,
              size: 46,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 18),

            const Text(
              'Nothing saved yet.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Find a cookie you love\nand tap the heart.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}