import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/cart.dart';
import 'package:flutter_application_1/components/cookie_image.dart';
import 'package:flutter_application_1/components/cookie_badge.dart';
import 'package:flutter_application_1/theme/label_colors.dart';

class DailyDropHero extends StatelessWidget {
  const DailyDropHero({super.key, required this.cookies});

  final List<Cookie> cookies;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('dailyDrops')
          .where('active', isEqualTo: true)
          .limit(1)
          .snapshots(),

      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _DropMessage(message: 'Unable to load today\'s drop.');
        }

        if (!snapshot.hasData) {
          return const SizedBox(
            height: 280,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return const _DropMessage(message: 'No Daily Drop today 🍪');
        }

        final dropDocument = snapshot.data!.docs.first;

        final dropData = dropDocument.data() as Map<String, dynamic>;

        final String cookieId = dropData['cookieId'] as String;

        final int stock = (dropData['stock'] as num).toInt();

        final int sold = (dropData['sold'] as num).toInt();

        final int remaining = (stock - sold).clamp(0, stock);

        final Timestamp endTimestamp = dropData['endTime'] as Timestamp;

        final DateTime endTime = endTimestamp.toDate();

        Cookie? dropCookie;

        for (final cookie in cookies) {
          if (cookie.cookieId == cookieId) {
            dropCookie = cookie;
            break;
          }
        }

        if (dropCookie == null) {
          return const _DropMessage(message: 'Daily Drop cookie not found.');
        }

        final cookie = dropCookie;

        final double stockProgress = stock == 0 ? 0 : remaining / stock;

        final bool soldOut = remaining == 0;

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 24 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP LABEL
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'TODAY\'S DROP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),

                    const Spacer(),

                    Text(
                      '$remaining LEFT',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // IMAGE + DETAILS
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: Transform.scale(
                        scale: cookie.imageScale,
                        child: CookieImage(
                          picture: cookie.picture,
                          name: cookie.name,
                        ),
                      ),
                    ),

                    const SizedBox(width: 18),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              CookieBadge(
                                label: cookie.label1,
                                color: labelColor(cookie.label1),
                              ),

                              CookieBadge(
                                label: cookie.label2,
                                color: labelColor(cookie.label2),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Text(
                            cookie.name,
                            style: const TextStyle(
                              fontSize: 24,
                              height: 1.05,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2D160E),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Text(
                                '€${cookie.discount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF2D160E),
                                ),
                              ),

                              const SizedBox(width: 7),

                              if (cookie.discount > 0)
                                Text(
                                  '€${cookie.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade500,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // STOCK BAR
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: stockProgress,
                    minHeight: 7,
                    backgroundColor: Colors.grey.shade200,
                    color: soldOut ? Colors.grey : Colors.black,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  soldOut
                      ? 'SOLD OUT'
                      : remaining <= 4
                      ? 'Almost gone — only $remaining left'
                      : '$remaining cookies available today',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: soldOut
                        ? Colors.grey
                        : remaining <= 4
                        ? Colors.red.shade700
                        : Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 16),

                _DropCountdown(endTime: endTime),

                const SizedBox(height: 16),

                // ADD BUTTON
                _DropPurchaseControls(cookie: cookie, remaining: remaining),
              ],
            ), // Column
          ), // Container
        ); // TweenAnimationBuilder
      },
    ); // StreamBuilder
  }
}

class _DropCountdown extends StatefulWidget {
  const _DropCountdown({required this.endTime});

  final DateTime endTime;

  @override
  State<_DropCountdown> createState() => _DropCountdownState();
}

class _DropCountdownState extends State<_DropCountdown> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();

    _updateRemaining();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  @override
  void didUpdateWidget(covariant _DropCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.endTime != widget.endTime) {
      _updateRemaining();
    }
  }

  void _updateRemaining() {
    final difference = widget.endTime.difference(DateTime.now());

    if (!mounted) return;

    setState(() {
      _remaining = difference.isNegative ? Duration.zero : difference;
    });
  }

  String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _remaining.inHours;

    final minutes = _remaining.inMinutes.remainder(60);

    final seconds = _remaining.inSeconds.remainder(60);

    final expired = _remaining == Duration.zero;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4F1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            expired ? 'DROP CLOSED' : 'DROP CLOSES IN',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            expired
                ? '00 : 00 : 00'
                : '${_twoDigits(hours)} : '
                      '${_twoDigits(minutes)} : '
                      '${_twoDigits(seconds)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: Color(0xFF2D160E),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropPurchaseControls extends StatefulWidget {
  const _DropPurchaseControls({required this.cookie, required this.remaining});

  final Cookie cookie;
  final int remaining;

  @override
  State<_DropPurchaseControls> createState() => _DropPurchaseControlsState();
}

class _DropPurchaseControlsState extends State<_DropPurchaseControls> {
  int quantity = 1;

  void _increase() {
    if (quantity < widget.remaining) {
      setState(() {
        quantity++;
      });
    }
  }

  void _decrease() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _addToCart() {
    for (int i = 0; i < quantity; i++) {
      Cart.add(widget.cookie);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$quantity × ${widget.cookie.name} added to cart 🍪'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final soldOut = widget.remaining == 0;

    final total = widget.cookie.discount * quantity;

    if (soldOut) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: FilledButton(
          onPressed: null,
          child: const Text(
            'SOLD OUT',
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.8),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            const Text(
              'QUANTITY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),

            const Spacer(),

            _DropQuantityButton(
              icon: CupertinoIcons.minus,
              enabled: quantity > 1,
              onPressed: _decrease,
            ),

            SizedBox(
              width: 48,
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D160E),
                ),
              ),
            ),

            _DropQuantityButton(
              icon: CupertinoIcons.plus,
              enabled: quantity < widget.remaining,
              onPressed: _increase,
            ),
          ],
        ),

        const SizedBox(height: 14),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: FilledButton(
            onPressed: _addToCart,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'ADD $quantity TO CART  •  €${total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropQuantityButton extends StatelessWidget {
  const _DropQuantityButton({
    required this.icon,
    required this.onPressed,
    required this.enabled,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFFF2EEE9) : Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 17,
          color: enabled ? const Color(0xFF2D160E) : Colors.grey.shade400,
        ),
      ),
    );
  }
}

class _DropMessage extends StatelessWidget {
  const _DropMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
