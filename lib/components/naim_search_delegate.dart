import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/screens/cart/cart_screen.dart';
import 'package:flutter_application_1/screens/home/views/details_screen.dart';
import 'package:flutter_application_1/screens/home/views/todays_drop_screen.dart';
import 'package:flutter_application_1/screens/journal/journal_screen.dart';

class NaimSearchDelegate extends SearchDelegate<String?> {
  final FirebaseCookieRepo _cookieRepo = FirebaseCookieRepo();

  @override
  String get searchFieldLabel => 'Search Naim...';

  @override
  TextStyle? get searchFieldStyle => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      );

  // X BUTTON
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close),
        ),
    ];
  }

  // BACK BUTTON
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // WHEN USER SUBMITS SEARCH
  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  // WHILE USER IS TYPING
  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final search = query.trim().toLowerCase();

    if (search.isEmpty) {
      return const Center(
        child: Text(
          'Search cookies, ingredients and Naim pages',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
      );
    }

    return FutureBuilder<List<Cookie>>(
      future: _cookieRepo.getCookies(),
      builder: (context, snapshot) {
        final results = <Widget>[];

        // -------------------------
        // APP SCREENS
        // -------------------------

        _addScreenResult(
          results: results,
          context: context,
          search: search,
          title: 'Today\'s Drop',
          subtitle: 'Today\'s featured cookie',
          keywords: [
            'today',
            'drop',
            'daily',
            'featured',
            'cookie',
          ],
          icon: Icons.auto_awesome_outlined,
          screen: const TodaysDropScreen(),
        );

        _addScreenResult(
          results: results,
          context: context,
          search: search,
          title: 'Naim Journal',
          subtitle: 'Stories, ingredients and articles',
          keywords: [
            'journal',
            'articles',
            'stories',
            'ingredients',
            'read',
          ],
          icon: Icons.menu_book_outlined,
          screen: const JournalScreen(),
        );

        _addScreenResult(
          results: results,
          context: context,
          search: search,
          title: 'Your Cart',
          subtitle: 'Your selected cookies',
          keywords: [
            'cart',
            'basket',
            'checkout',
            'order',
          ],
          icon: Icons.shopping_bag_outlined,
          screen: const CartScreen(),
        );

        // -------------------------
        // COOKIES
        // -------------------------

        if (snapshot.hasData) {
          final cookies = snapshot.data!;

          final matchingCookies = cookies.where((cookie) {
            final searchableText = [
              cookie.name,
              cookie.description,
              cookie.ingredients,
              cookie.label1,
              cookie.label2,
            ].join(' ').toLowerCase();

            return searchableText.contains(search);
          });

          for (final cookie in matchingCookies) {
            results.add(
              _SearchResultTile(
                icon: Icons.cookie_outlined,
                title: cookie.name,
                subtitle: 'Cookie',
                onTap: () {
                  close(context, null);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DetailsScreen(
                        cookie: cookie,
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }

        // Loading Firebase
        if (snapshot.connectionState == ConnectionState.waiting &&
            results.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Nothing found
        if (results.isEmpty) {
          return Center(
            child: Text(
              'No results for "$query"',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
          children: results,
        );
      },
    );
  }

  void _addScreenResult({
    required List<Widget> results,
    required BuildContext context,
    required String search,
    required String title,
    required String subtitle,
    required List<String> keywords,
    required IconData icon,
    required Widget screen,
  }) {
    final searchableText = [
      title,
      subtitle,
      ...keywords,
    ].join(' ').toLowerCase();

    if (!searchableText.contains(search)) {
      return;
    }

    results.add(
      _SearchResultTile(
        icon: icon,
        title: title,
        subtitle: subtitle,
        onTap: () {
          close(context, null);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => screen,
            ),
          );
        },
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2EEE9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}