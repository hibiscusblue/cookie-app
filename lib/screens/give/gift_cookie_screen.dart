import 'package:flutter/material.dart';

import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';

class GiftCookieScreen extends StatefulWidget {
  const GiftCookieScreen({super.key});

  @override
  State<GiftCookieScreen> createState() => _GiftCookieScreenState();
}

class _GiftCookieScreenState extends State<GiftCookieScreen> {
  final recipientController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void dispose() {
    recipientController.dispose();
    messageController.dispose();
    super.dispose();
  }

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
              'A Naim moment, chosen especially for someone.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),

            _GiftField(
              label: 'RECIPIENT',
              hint: 'Their name',
              controller: recipientController,
            ),

            const SizedBox(height: 20),

            const Text(
              'YOUR MESSAGE',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1,
                fontWeight: FontWeight.w900,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: messageController,
              maxLines: 5,
              maxLength: 200,
              decoration: InputDecoration(
                hintText: 'A little message for them...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

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
                  Icon(
                    Icons.card_giftcard,
                    color: Color(0xFF2D160E),
                  ),

                  SizedBox(width: 14),

                  Expanded(
                    child: Text(
                      'Next you will choose the cookies and the delivery address.',
                      style: TextStyle(
                        height: 1.5,
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
                  // We will connect cookie selection next.
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
                  'CHOOSE COOKIES',
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

class _GiftField extends StatelessWidget {
  const _GiftField({
    required this.label,
    required this.hint,
    required this.controller,
  });

  final String label;
  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 1,
            fontWeight: FontWeight.w900,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}