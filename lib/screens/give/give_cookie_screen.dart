import 'package:flutter/material.dart';

import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';

class GiveCookieScreen extends StatefulWidget {
  const GiveCookieScreen({super.key});

  @override
  State<GiveCookieScreen> createState() => _GiveCookieScreenState();
}

class _GiveCookieScreenState extends State<GiveCookieScreen> {
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
              'GIVE A COOKIE',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Choose how many moments of sweetness you would like to give.',
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
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.favorite_outline,
                    size: 46,
                    color: Color(0xFF2D160E),
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
                        onTap: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    quantity == 1
                        ? '1 cookie for someone else'
                        : '$quantity cookies for someone else',
                    style: TextStyle(
                      color: Colors.grey.shade600,
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
              child: const Text(
                'We will later connect this to a verified community or charity '
                'partner so every sponsored cookie has a clear destination.',
                style: TextStyle(
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  // We will connect this to checkout later.
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 17,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
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
      ),
      icon: Icon(icon),
    );
  }
}