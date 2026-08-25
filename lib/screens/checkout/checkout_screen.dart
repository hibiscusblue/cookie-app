import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/cart.dart';
import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),
      body: authUser == null
          ? const Center(
              child: Text(
                'Please sign in to continue with checkout.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            )
          : FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(authUser.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }

                final data = snapshot.data?.data();

                final name = data?['name']?.toString().trim() ?? '';

                final email =
                    data?['email']?.toString().trim() ?? authUser.email ?? '';

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CHECKOUT',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Almost yours.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 28),

                      const _SectionTitle(title: 'YOUR ORDER'),

                      const SizedBox(height: 12),

                      ..._buildOrderItems(),

                      const SizedBox(height: 10),

                      const Divider(),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TOTAL',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            '€${Cart.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2D160E),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      const _SectionTitle(title: 'CONTACT'),

                      const SizedBox(height: 12),

                      _InfoCard(
                        children: [
                          _InfoRow(
                            label: 'Name',
                            value: name.isNotEmpty ? name : 'Not added',
                          ),
                          const SizedBox(height: 14),
                          _InfoRow(
                            label: 'Email',
                            value: email.isNotEmpty ? email : 'Not available',
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      const _SectionTitle(title: 'PICKUP'),

                      const SizedBox(height: 12),

                      const _InfoCard(
                        children: [
                          _InfoRow(label: 'Method', value: 'Pickup'),
                          SizedBox(height: 14),
                          _InfoRow(label: 'Location', value: 'Venlo'),
                        ],
                      ),

                      const SizedBox(height: 28),

                      const _SectionTitle(title: 'PAYMENT'),

                      const SizedBox(height: 12),

                      const _InfoCard(
                        children: [
                          _InfoRow(label: 'Method', value: 'Tikkie'),
                          SizedBox(height: 6),
                          Text(
                            'Payment connection will be added later.',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: () async {
                            try {
                              final user = FirebaseAuth.instance.currentUser;

                              if (user == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please sign in before placing an order.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final uniqueCookies = <dynamic>[];

                              for (final cookie in Cart.items) {
                                final alreadyAdded = uniqueCookies.any(
                                  (item) => item.cookieId == cookie.cookieId,
                                );

                                if (!alreadyAdded) {
                                  uniqueCookies.add(cookie);
                                }
                              }

                              final orderItems = uniqueCookies.map((cookie) {
                                final quantity = Cart.quantityFor(cookie);

                                final unitPrice = cookie.discount > 0
                                    ? cookie.discount
                                    : cookie.price;

                                return {
                                  'cookieId': cookie.cookieId,
                                  'name': cookie.name,
                                  'picture': cookie.picture,
                                  'quantity': quantity,
                                  'unitPrice': unitPrice,
                                  'subtotal': unitPrice * quantity,
                                };
                              }).toList();

                              final orderRef = FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc();

                              await orderRef.set({
                                'orderId': orderRef.id,
                                'userId': user.uid,
                                'email': user.email,
                                'items': orderItems,
                                'total': Cart.total,
                                'orderStatus': 'pending',
                                'paymentStatus': 'unpaid',
                                'paymentMethod': 'tikkie',
                                'fulfilmentMethod': 'pickup',
                                'pickupLocation': 'Venlo',
                                'createdAt': FieldValue.serverTimestamp(),
                              });

                              Cart.clear();

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Your Naim order has been created 🍪',
                                  ),
                                ),
                              );

                              Navigator.of(
                                context,
                              ).popUntil((route) => route.isFirst);
                            } catch (e) {
                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Could not place order: $e'),
                                ),
                              );

                              debugPrint('ORDER ERROR: $e');
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'PLACE ORDER  •  €${Cart.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
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

  List<Widget> _buildOrderItems() {
    final uniqueCookies = <dynamic>[];

    for (final cookie in Cart.items) {
      final alreadyAdded = uniqueCookies.any(
        (item) => item.cookieId == cookie.cookieId,
      );

      if (!alreadyAdded) {
        uniqueCookies.add(cookie);
      }
    }

    return uniqueCookies.map<Widget>((cookie) {
      final quantity = Cart.quantityFor(cookie);

      final unitPrice = cookie.discount > 0 ? cookie.discount : cookie.price;

      final subtotal = unitPrice * quantity;

      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                cookie.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            Text(
              '× $quantity',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),

            const SizedBox(width: 18),

            Text(
              '€${subtotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.3,
        color: Colors.grey.shade500,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color: Colors.grey.shade500,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
