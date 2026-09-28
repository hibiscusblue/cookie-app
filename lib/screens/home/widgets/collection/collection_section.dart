import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_repository/cookie_repository.dart';

import 'package:flutter_application_1/favorites.dart';
import 'package:flutter_application_1/components/naim_footer.dart';

import 'cookie_card.dart';

class CollectionSection extends StatefulWidget {
  const CollectionSection({
    super.key,
    required this.cookies,
    this.scrollable = true,
  });

  final List<Cookie> cookies;
  final bool scrollable;

  @override
  State<CollectionSection> createState() => _CollectionSectionState();
}

class _CollectionSectionState extends State<CollectionSection> {
  @override
  void initState() {
    super.initState();
    Favorites.load();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('appSettings')
          .doc('shop')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: SelectableText(
              'Firestore error:\n${snapshot.error}',
              textAlign: TextAlign.center,
            ),
          );
        }

        final data = snapshot.data?.data();

        final bool purchasingEnabled =
            data?['collectionPurchasingEnabled'] == true;

        return CustomScrollView(
          shrinkWrap: !widget.scrollable,
          physics: widget.scrollable
              ? null
              : const NeverScrollableScrollPhysics(),
          slivers: [
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

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Our most-loved cookies',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 14)),

            SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final cookie = widget.cookies[index];

                return CookieCard(
                  cookie: cookie,
                  purchasingEnabled: purchasingEnabled,
                );
              }, childCount: widget.cookies.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.sizeOf(context).width >= 900 ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.68,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            const SliverToBoxAdapter(child: NaimFooter()),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),
          ],
        );
      },
    );
  }
}
