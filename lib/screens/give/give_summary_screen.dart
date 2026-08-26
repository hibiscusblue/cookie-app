import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/give/give_checkout_screen.dart';
import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';

class GiveSummaryScreen extends StatelessWidget {
  const GiveSummaryScreen({
    super.key,
    required this.selectedCookies,
    required this.chefChoiceCount,
  });

  final Map<String, int> selectedCookies;
  final int chefChoiceCount;

  int get totalQuantity {
    int total = chefChoiceCount;

    for (final count in selectedCookies.values) {
      total += count;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),

      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('cookies').get(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Unable to load your gift.',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            );
          }

          final cookieDocs = snapshot.data?.docs ?? [];

          final selectedItems = cookieDocs.where((document) {
            return selectedCookies.containsKey(document.id);
          }).toList();

          double totalPrice = 0;

          for (final document in selectedItems) {
            final data = document.data();

            final quantity = selectedCookies[document.id] ?? 0;

            final price =
                (data['discount'] as num?)?.toDouble() ??
                (data['price'] as num?)?.toDouble() ??
                0;

            totalPrice += price * quantity;
          }

          // Chef's Choice price:
          // For now we use €2.99 per cookie.
          const chefChoicePrice = 2.99;

          totalPrice += chefChoiceCount * chefChoicePrice;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 40),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YOUR GIFT',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                ),

                const SizedBox(height: 8),

                Text(
                  totalQuantity == 1
                      ? 'One little moment of bliss for someone else.'
                      : '$totalQuantity little moments of bliss for someone else.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 28),

                // =========================================================
                // GIFT ITEMS
                // =========================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                  ),

                  child: Column(
                    children: [
                      ...selectedItems.map((document) {
                        final data = document.data();

                        final name = data['name']?.toString() ?? 'Naim Cookie';

                        final picture = data['picture']?.toString() ?? '';

                        final imageScale =
                            (data['imageScale'] as num?)?.toDouble() ?? 1.0;

                        final quantity = selectedCookies[document.id] ?? 0;

                        final price =
                            (data['discount'] as num?)?.toDouble() ??
                            (data['price'] as num?)?.toDouble() ??
                            0;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),

                          child: _GiftItem(
                            name: name,
                            picture: picture,
                            imageScale: imageScale,
                            quantity: quantity,
                            price: price,
                          ),
                        );
                      }),

                      if (chefChoiceCount > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18),

                          child: _ChefChoiceItem(
                            quantity: chefChoiceCount,
                            price: chefChoicePrice,
                          ),
                        ),

                      Divider(color: Colors.grey.shade200),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          const Text(
                            'TOTAL',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),

                          const Spacer(),

                          Text(
                            '€${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // =========================================================
                // PURPOSE
                // =========================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: const Color(0xFFF2EEE9),
                    borderRadius: BorderRadius.circular(22),
                  ),

                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.favorite_outline, color: Color(0xFF2D160E)),

                      SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'A cookie for someone else',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),

                            SizedBox(height: 6),

                            Text(
                              'Your gift will be prepared as part of Naim\'s giving collection. '
                              'We will connect donated cookies with a verified community or charity partner.',
                              style: TextStyle(height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // =========================================================
                // CHECKOUT
                // =========================================================
                SizedBox(
                  width: double.infinity,

                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => GiveCheckoutScreen(
                            selectedCookies: Map<String, int>.from(
                              selectedCookies,
                            ),
                            chefChoiceCount: chefChoiceCount,
                            totalPrice: totalPrice,
                          ),
                        ),
                      );
                    },

                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,

                      padding: const EdgeInsets.symmetric(vertical: 17),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: const Text(
                      'CONTINUE TO CHECKOUT',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==========================================================================
// NORMAL COOKIE
// ==========================================================================

class _GiftItem extends StatelessWidget {
  const _GiftItem({
    required this.name,
    required this.picture,
    required this.imageScale,
    required this.quantity,
    required this.price,
  });

  final String name;
  final String picture;
  final double imageScale;
  final int quantity;
  final double price;

  @override
  Widget build(BuildContext context) {
    final itemTotal = price * quantity;

    return Row(
      children: [
        Container(
          width: 62,
          height: 62,

          decoration: BoxDecoration(
            color: const Color(0xFFF2EEE9),
            borderRadius: BorderRadius.circular(16),
          ),

          child: picture.isEmpty
              ? const Icon(Icons.cookie_outlined, color: Color(0xFF2D160E))
              : Padding(
                  padding: const EdgeInsets.all(6),

                  child: Transform.scale(
                    scale: imageScale,

                    child: Image.network(
                      picture,
                      fit: BoxFit.contain,

                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.cookie_outlined);
                      },
                    ),
                  ),
                ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                '$quantity × €${price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),

        Text(
          '€${itemTotal.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

// ==========================================================================
// CHEF'S CHOICE
// ==========================================================================

class _ChefChoiceItem extends StatelessWidget {
  const _ChefChoiceItem({required this.quantity, required this.price});

  final int quantity;
  final double price;

  @override
  Widget build(BuildContext context) {
    final itemTotal = price * quantity;

    return Row(
      children: [
        Container(
          width: 62,
          height: 62,

          decoration: BoxDecoration(
            color: const Color(0xFFF2EEE9),
            borderRadius: BorderRadius.circular(16),
          ),

          child: const Icon(
            Icons.auto_awesome,
            color: Color(0xFF2D160E),
            size: 28,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chef\'s Choice',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),

              const SizedBox(height: 4),

              Text(
                '$quantity × €${price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),

        Text(
          '€${itemTotal.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}
