import 'package:flutter/material.dart';
import 'package:cookie_repository/cookie_repository.dart';

import 'package:flutter_application_1/favorites.dart';
import 'package:flutter_application_1/components/naim_footer.dart';

import 'cookie_card.dart';

class CollectionSection extends StatefulWidget {
  const CollectionSection({
    super.key,
    required this.cookies,
  });

  final List<Cookie> cookies;

  @override
  State<CollectionSection> createState() =>
      _CollectionSectionState();
}

class _CollectionSectionState
    extends State<CollectionSection> {
  @override
  void initState() {
    super.initState();
    Favorites.load();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // COLLECTION TITLE
        const SliverToBoxAdapter(
          child: Text(
            'THE COLLECTION',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // SUBTITLE
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Our most-loved cookies',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 14),
        ),

        // COOKIE GRID
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return CookieCard(
                cookie: widget.cookies[index],
              );
            },
            childCount: widget.cookies.length,
          ),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.68,
          ),
        ),

        // SPACE AFTER LAST ROW
        const SliverToBoxAdapter(
          child: SizedBox(height: 28),
        ),

        // FOOTER
        const SliverToBoxAdapter(
          child: NaimFooter(),
        ),

        // SMALL BOTTOM SPACE
        const SliverToBoxAdapter(
          child: SizedBox(height: 8),
        ),
      ],
    );
  }
}