import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/give/give_checkout_screen.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';

class GiveSummaryScreen extends StatelessWidget {
  const GiveSummaryScreen({
    super.key,
    required this.selectedCookies,
    required this.chefChoiceCount,
    this.charityName,
    this.recipientName,
    this.giftMessage,
  });

  final Map<String, int> selectedCookies;
  final int chefChoiceCount;

  final String? charityName;
  final String? recipientName;
  final String? giftMessage;

  bool get isDonation => charityName != null;

  int get totalQuantity {
    int total = chefChoiceCount;

    for (final count in selectedCookies.values) {
      total += count;
    }

    return total;
  }

  double _cookiePrice(Map<String, dynamic> data) {
    final normalPrice =
        (data['price'] as num?)?.toDouble() ?? 0.0;

    final discount =
        (data['discount'] as num?)?.toDouble() ?? 0.0;

    return discount > 0 ? discount : normalPrice;
  }

  Future<void> _confirmDonation(
    BuildContext context,
    double totalPrice,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in first.'),
        ),
      );

      return;
    }

    try {
      final firestore = FirebaseFirestore.instance;

      // ============================================================
      // LOAD COOKIE INFORMATION
      // ============================================================

      final cookieSnapshot =
          await firestore.collection('cookies').get();

      final List<Map<String, dynamic>> orderItems = [];

      for (final cookieDoc in cookieSnapshot.docs) {
        final quantity =
            selectedCookies[cookieDoc.id] ?? 0;

        if (quantity <= 0) {
          continue;
        }

        final data = cookieDoc.data();

        final name =
            data['name']?.toString() ?? 'Naim Cookie';

        final price = _cookiePrice(data);

        orderItems.add({
          'cookieId': cookieDoc.id,
          'name': name,
          'quantity': quantity,
          'price': price,
          'subtotal': price * quantity,
          'isChefChoice': false,
        });
      }

      // ============================================================
      // CHEF'S CHOICE
      // ============================================================

      if (chefChoiceCount > 0) {
        const chefChoicePrice = 2.99;

        orderItems.add({
          'cookieId': 'chef_choice',
          'name': 'Chef\'s Choice',
          'quantity': chefChoiceCount,
          'price': chefChoicePrice,
          'subtotal': chefChoicePrice * chefChoiceCount,
          'isChefChoice': true,
        });
      }

      // ============================================================
      // CREATE DONATION ORDER
      // ============================================================

      final orderRef =
          firestore.collection('orders').doc();

      final orderId = orderRef.id;

      final orderNumber =
          'DONATION-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

      await orderRef.set({
        'orderId': orderId,
        'orderNumber': orderNumber,

        'userId': user.uid,

        // Tells us this is a charity donation.
        'orderType': 'donation',

        // Selected charity, for example Voedselbank.
        'charityName': charityName,

        'items': orderItems,

        'total': totalPrice,

        'orderStatus': 'pending',
        'paymentStatus': 'unpaid',

        'chefChoiceCount': chefChoiceCount,

        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => DonationSuccessScreen(
            charityName:
                charityName ?? 'the selected charity',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not confirm donation: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.surface,
      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),

      body: FutureBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('cookies')
            .get(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Unable to load your gift.',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }

          final cookieDocs =
              snapshot.data?.docs ?? [];

          final selectedItems =
              cookieDocs.where((document) {
            return selectedCookies
                .containsKey(document.id);
          }).toList();

          double totalPrice = 0;

          for (final document in selectedItems) {
            final data = document.data();

            final quantity =
                selectedCookies[document.id] ?? 0;

            final price = _cookiePrice(data);

            totalPrice += price * quantity;
          }

          // Chef's Choice price
          const chefChoicePrice = 2.99;

          totalPrice +=
              chefChoiceCount * chefChoicePrice;

          return SingleChildScrollView(
            padding:
                const EdgeInsets.fromLTRB(
              24,
              18,
              24,
              40,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  isDonation
                      ? 'YOUR DONATION'
                      : 'YOUR GIFT',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  _subtitleText(),
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 28),

                // =====================================================
                // ITEMS
                // =====================================================
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(26),
                  ),
                  child: Column(
                    children: [
                      ...selectedItems.map(
                        (document) {
                          final data =
                              document.data();

                          final name =
                              data['name']
                                      ?.toString() ??
                                  'Naim Cookie';

                          final picture =
                              data['picture']
                                      ?.toString() ??
                                  '';

                          final imageScale =
                              (data['imageScale']
                                          as num?)
                                      ?.toDouble() ??
                                  1.0;

                          final quantity =
                              selectedCookies[
                                      document.id] ??
                                  0;

                          final price =
                              _cookiePrice(data);

                          return Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 18,
                            ),
                            child: _GiftItem(
                              name: name,
                              picture: picture,
                              imageScale:
                                  imageScale,
                              quantity:
                                  quantity,
                              price: price,
                            ),
                          );
                        },
                      ),

                      if (chefChoiceCount > 0)
                        const SizedBox(
                          height: 0,
                        ),

                      if (chefChoiceCount > 0)
                        Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 18,
                          ),
                          child:
                              _ChefChoiceItem(
                            quantity:
                                chefChoiceCount,
                            price:
                                chefChoicePrice,
                          ),
                        ),

                      Divider(
                        color:
                            Colors.grey.shade200,
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          const Text(
                            'TOTAL',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),

                          const Spacer(),

                          Text(
                            '€${totalPrice.toStringAsFixed(2)}',
                            style:
                                const TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // =====================================================
                // PURPOSE / INFO
                // =====================================================
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFFF2EEE9),
                    borderRadius:
                        BorderRadius.circular(22),
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isDonation
                            ? Icons
                                  .volunteer_activism_outlined
                            : Icons
                                  .favorite_outline,
                        color:
                            const Color(0xFF2D160E),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              isDonation
                                  ? 'A cookie for ${charityName ?? 'someone else'}'
                                  : 'A cookie for someone special',
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.w900,
                              ),
                            ),

                            const SizedBox(
                              height: 6,
                            ),

                            Text(
                              isDonation
                                  ? 'Your donation will be prepared as part of Naim\'s giving collection and delivered to ${charityName ?? 'the selected organisation'}.'
                                  : 'After continuing to checkout, you can add the recipient\'s delivery address and a personal message.',
                              style:
                                  const TextStyle(
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // =====================================================
                // CONTINUE / CONFIRM
                // =====================================================
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      if (isDonation) {
                        await _confirmDonation(
                          context,
                          totalPrice,
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                GiveCheckoutScreen(
                              selectedCookies:
                                  Map<
                                    String,
                                    int
                                  >.from(
                                    selectedCookies,
                                  ),
                              chefChoiceCount:
                                  chefChoiceCount,
                              totalPrice:
                                  totalPrice,
                            ),
                          ),
                        );
                      }
                    },
                    style:
                        FilledButton.styleFrom(
                      backgroundColor:
                          Colors.black,
                      foregroundColor:
                          Colors.white,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 17,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),
                    child: Text(
                      isDonation
                          ? 'CONFIRM DONATION'
                          : 'CONTINUE TO CHECKOUT',
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.w900,
                      ),
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

  String _subtitleText() {
    if (isDonation) {
      if (totalQuantity == 1) {
        return 'One little moment of bliss for ${charityName ?? 'someone else'}.';
      }

      return '$totalQuantity little moments of bliss for ${charityName ?? 'someone else'}.';
    }

    if (totalQuantity == 1) {
      return 'One little moment of bliss for someone special.';
    }

    return '$totalQuantity little moments of bliss for someone special.';
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
            color:
                const Color(0xFFF2EEE9),
            borderRadius:
                BorderRadius.circular(16),
          ),
          child: picture.isEmpty
              ? const Icon(
                  Icons.cookie_outlined,
                  color:
                      Color(0xFF2D160E),
                )
              : Padding(
                  padding:
                      const EdgeInsets.all(6),
                  child: Transform.scale(
                    scale: imageScale,
                    child: Image.network(
                      picture,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (
                            context,
                            error,
                            stackTrace,
                          ) {
                        return const Icon(
                          Icons.cookie_outlined,
                        );
                      },
                    ),
                  ),
                ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style:
                    const TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                '$quantity × €${price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 13,
                  color:
                      Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        Text(
          '€${itemTotal.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight:
                FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

// ==========================================================================
// CHEF'S CHOICE
// ==========================================================================

class _ChefChoiceItem
    extends StatelessWidget {
  const _ChefChoiceItem({
    required this.quantity,
    required this.price,
  });

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
            color:
                const Color(0xFFF2EEE9),
            borderRadius:
                BorderRadius.circular(16),
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
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Chef\'s Choice',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                '$quantity × €${price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 13,
                  color:
                      Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        Text(
          '€${itemTotal.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight:
                FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

// ==========================================================================
// DONATION SUCCESS SCREEN
// ==========================================================================

class DonationSuccessScreen
    extends StatelessWidget {
  const DonationSuccessScreen({
    super.key,
    required this.charityName,
  });

  final String charityName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .colorScheme
              .surface,
      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),

      body: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Center(
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration:
                      const BoxDecoration(
                    color:
                        Color(0xFFF2EEE9),
                    shape:
                        BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 34,
                    color:
                        Color(0xFF2D160E),
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),

                const Text(
                  'THANK YOU',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                const Text(
                  'Your donation was successful.',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Text(
                  'Your cookies will be prepared as part of '
                  'Naim\'s giving collection for $charityName.',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color:
                        Colors.grey.shade600,
                  ),
                ),

                const SizedBox(
                  height: 28,
                ),

                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(
                //     horizontal: 16,
                //     vertical: 10,
                //   ),
                //   decoration:
                //       BoxDecoration(
                //     color:
                //         const Color(
                //           0xFFF2EEE9,
                //         ),
                //     borderRadius:
                //         BorderRadius.circular(
                //       100,
                //     ),
                //   ),
                //   child: const Text(
                //     'DONATION CONFIRMED',
                //     style: TextStyle(
                //       fontSize: 11,
                //       fontWeight:
                //           FontWeight.w900,
                //       letterSpacing: 1,
                //     ),
                //   ),
                // ),

                // const SizedBox(
                //   height: 30,
                // ),

                SizedBox(
                  width:
                      double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context)
                          .popUntil(
                        (route) =>
                            route.isFirst,
                      );
                    },
                    style:
                        FilledButton
                            .styleFrom(
                      backgroundColor:
                          Colors.black,
                      foregroundColor:
                          Colors.white,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 17,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),
                    child:
                        const Text(
                      'BACK TO NAIM',
                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight
                                .w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}