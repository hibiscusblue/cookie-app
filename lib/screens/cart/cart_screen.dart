import 'package:flutter/material.dart';
import 'package:flutter_application_1/cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F8),
        title: const Text(
          'YOUR CART',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      body: Cart.items.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty 🍪',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: Cart.items.length,
                    itemBuilder: (context, index) {
                      final cookie = Cart.items[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cookie.name,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '€${cookie.discount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF2D160E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    Cart.remove(cookie);
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TOTAL',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '€${Cart.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF2D160E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}