import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/components/cookie_image.dart';
import 'package:flutter_application_1/screens/cart/cart_screen.dart';
import 'package:flutter_application_1/screens/home/views/details_screen.dart';
import 'package:flutter_application_1/screens/home/views/todays_drop_screen.dart';
import 'package:flutter_application_1/screens/journal/article_screen.dart';
import 'package:flutter_application_1/screens/journal/journal_article.dart';
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

  // CLEAR BUTTON
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

  // WHEN ENTER IS PRESSED
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
          'Search anything in Naim',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
      );
    }

    return FutureBuilder<_SearchData>(
      future: _loadSearchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Unable to search Naim right now.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!;
        final results = <Widget>[];

        // =====================================================
        // APP SCREENS
        // =====================================================

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
            'blog',
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

        // =====================================================
        // COOKIES
        // =====================================================

        final matchingCookies = data.cookies.where((cookie) {
          final searchableText = [
            cookie.name,
            cookie.description,
            cookie.ingredients,
            cookie.label1,
            cookie.label2,
          ].join(' ').toLowerCase();

          return searchableText.contains(search);
        }).toList();

        for (final cookie in matchingCookies) {
          results.add(
            _SearchResultTile(
              leading: CookieImage(
                picture: cookie.picture,
                name: cookie.name,
              ),
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

        // =====================================================
        // JOURNAL ARTICLES
        // =====================================================

        final matchingArticles = data.articles.where((article) {
          final searchableText = [
            article.title,
            article.subtitle,
            article.category,
            article.content,
          ].join(' ').toLowerCase();

          return searchableText.contains(search);
        }).toList();

        for (final article in matchingArticles) {
          results.add(
            _SearchResultTile(
              leading: _JournalSearchImage(
                imageUrl: article.image,
              ),
              title: article.title,
              subtitle: 'Journal · ${article.category}',
              onTap: () {
                close(context, null);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ArticleScreen(
                      article: article,
                    ),
                  ),
                );
              },
            ),
          );
        }

        // =====================================================
        // NO RESULTS
        // =====================================================

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

        // =====================================================
        // RESULTS
        // =====================================================

        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
          children: results,
        );
      },
    );
  }

  // =========================================================
  // LOAD EVERYTHING SEARCHABLE
  // =========================================================

  Future<_SearchData> _loadSearchData() async {
    final cookies = await _cookieRepo.getCookies();

    final journalSnapshot = await FirebaseFirestore.instance
        .collection('journal_articles')
        .orderBy('date', descending: true)
        .get();

    final articles = journalSnapshot.docs
        .map((doc) => JournalArticle.fromDocument(doc))
        .toList();

    return _SearchData(
      cookies: cookies,
      articles: articles,
    );
  }

  // =========================================================
  // FIXED SCREEN SEARCH
  // =========================================================

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

// ===========================================================
// SEARCH DATA
// ===========================================================

class _SearchData {
  const _SearchData({
    required this.cookies,
    required this.articles,
  });

  final List<Cookie> cookies;
  final List<JournalArticle> articles;
}

// ===========================================================
// JOURNAL IMAGE
// ===========================================================

class _JournalSearchImage extends StatelessWidget {
  const _JournalSearchImage({
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const Center(
        child: Icon(
          Icons.auto_stories_outlined,
          size: 24,
          color: Color(0xFF2D160E),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.auto_stories_outlined,
              size: 24,
              color: Color(0xFF2D160E),
            ),
          );
        },
      ),
    );
  }
}

// ===========================================================
// SEARCH RESULT CARD
// ===========================================================

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.icon,
    this.leading,
  });

  final IconData? icon;
  final Widget? leading;

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
                  width: 54,
                  height: 54,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2EEE9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: leading ??
                      Icon(
                        icon,
                        size: 22,
                      ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

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