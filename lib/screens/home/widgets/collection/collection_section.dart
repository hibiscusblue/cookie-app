import 'package:flutter/material.dart';
import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter_application_1/favorites.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),

        const SizedBox(height: 14),

        Expanded(
          child: GridView.builder(
            itemCount: widget.cookies.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (context, index) {
              return CookieCard(
                cookie: widget.cookies[index],
              );
            },
          ),
        ),
      ],
    );
  }
}