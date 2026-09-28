import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/components/naim_footer.dart';
import 'package:flutter_application_1/favorites.dart';
import 'package:flutter_application_1/screens/home/blocs/get_cookie_bloc/get_cookie_bloc.dart';
import 'package:flutter_application_1/screens/home/widgets/collection/cookie_card.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetCookieBloc(FirebaseCookieRepo())..add(GetCookie()),
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

      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('appSettings')
            .doc('shop')
            .snapshots(),
        builder: (context, shopSnapshot) {
          final shopData = shopSnapshot.data?.data();

          final bool purchasingEnabled =
              shopData?['collectionPurchasingEnabled'] == true;

          return BlocBuilder<GetCookieBloc, GetCookieState>(
            builder: (context, state) {
              if (state is GetCookieFailure) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                );
              }

              if (state is! GetCookieSuccess) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              }

              return FutureBuilder<void>(
                future: Favorites.load(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    );
                  }

                  return ValueListenableBuilder<int>(
                    valueListenable: Favorites.changes,
                    builder: (context, _, _) {
                      final favoriteCookies = state.cookies
                          .where((cookie) => Favorites.contains(cookie))
                          .toList();

                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 700),
                          child: CustomScrollView(
                            slivers: [
                              // PAGE PADDING + TITLE
                              SliverPadding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  16,
                                  16,
                                  0,
                                ),
                                sliver: SliverList(
                                  delegate: SliverChildListDelegate([
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
                                  ]),
                                ),
                              ),

                              // EMPTY FAVORITES
                              if (favoriteCookies.isEmpty)
                                const SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: _EmptyFavorites(),
                                ),

                              // FAVORITES GRID
                              if (favoriteCookies.isNotEmpty)
                                SliverPadding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  sliver: SliverGrid(
                                    delegate: SliverChildBuilderDelegate((
                                      context,
                                      index,
                                    ) {
                                      return CookieCard(
                                        cookie: favoriteCookies[index],
                                        purchasingEnabled: purchasingEnabled,
                                      );
                                    }, childCount: favoriteCookies.length),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              MediaQuery.sizeOf(
                                                    context,
                                                  ).width >=
                                                  600
                                              ? 3
                                              : 2,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                          childAspectRatio: 0.68,
                                        ),
                                  ),
                                ),

                              // SPACE BEFORE FOOTER
                              if (favoriteCookies.isNotEmpty)
                                const SliverToBoxAdapter(
                                  child: SizedBox(height: 28),
                                ),

                              // FOOTER
                              if (favoriteCookies.isNotEmpty)
                                const SliverToBoxAdapter(child: NaimFooter()),

                              // SMALL SPACE UNDER FOOTER
                              if (favoriteCookies.isNotEmpty)
                                const SliverToBoxAdapter(
                                  child: SizedBox(height: 8),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
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
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.heart, size: 46, color: Colors.grey.shade400),

            const SizedBox(height: 18),

            const Text(
              'Nothing saved yet.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
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
