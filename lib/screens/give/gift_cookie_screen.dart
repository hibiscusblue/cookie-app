import 'package:flutter/material.dart';

import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';
import 'package:flutter_application_1/screens/give/give_cookie_selection_screen.dart';

class GiftCookieScreen extends StatefulWidget {
  const GiftCookieScreen({super.key});

  @override
  State<GiftCookieScreen> createState() => _GiftCookieScreenState();
}

class _GiftCookieScreenState extends State<GiftCookieScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SEND A GIFT',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Choose how many moments of Naim you would like to send.',
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: Colors.black.withOpacity(0.04),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2EEE9),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.card_giftcard_outlined,
                      size: 28,
                      color: Color(0xFF2D160E),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'How many cookies?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _QuantityButton(
                        icon: Icons.remove,
                        onTap: quantity > 1
                            ? () {
                                setState(() {
                                  quantity--;
                                });
                              }
                            : null,
                      ),

                      SizedBox(
                        width: 90,
                        child: Center(
                          child: Text(
                            '$quantity',
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),

                      _QuantityButton(
                        icon: Icons.add,
                        onTap: quantity < 12
                            ? () {
                                setState(() {
                                  quantity++;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    quantity == 1
                        ? '1 cookie to gift'
                        : '$quantity cookies to gift',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Maximum 12 cookies per gift',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF2EEE9),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.favorite_outline,
                    color: Color(0xFF2D160E),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Text(
                      'After choosing the cookies, you can add the '
                      'recipient, delivery address and a personal message.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GiveCookieSelectionScreen(
                        quantity: quantity,
                      ),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 17,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'CHOOSE COOKIES',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey.shade300,
        disabledForegroundColor: Colors.white,
      ),
      icon: Icon(icon),
    );
  }
}