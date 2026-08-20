import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/cart.dart';
import 'package:flutter_application_1/components/cookie_badge.dart';
import 'package:flutter_application_1/components/cookie_image.dart';
import 'package:flutter_application_1/screens/home/views/details_screen.dart';
import 'package:flutter_application_1/theme/label_colors.dart';

class CookieCard extends StatelessWidget {
  const CookieCard({required this.cookie});

  final Cookie cookie;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => DetailsScreen(cookie: cookie),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox.expand(
                  child: Center(
                    child: Transform.scale(
                      scale: cookie.name.trim().toLowerCase() == 'marzipan'
                          ? 0.60
                          : 1.0,
                      child: CookieImage(
                        picture: cookie.picture,
                        name: cookie.name,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FRUITY + BALANCE
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
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

                  const SizedBox(height: 8),

                  // COOKIE NAME
                  Text(
                    cookie.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // DESCRIPTION
                  // Text(
                  //   cookie.description,
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  // ),
                  const SizedBox(height: 6),

                  // PRICE + ADD BUTTON
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 5,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              '€${cookie.discount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2D160E),
                              ),
                            ),

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
                      ),

                      ValueListenableBuilder<int>(
                        valueListenable: Cart.changes,
                        builder: (context, _, _) {
                          final quantity = Cart.quantityFor(cookie);

                          if (quantity == 0) {
                            return IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                Cart.add(cookie);
                              },
                              icon: const Icon(
                                CupertinoIcons.add_circled_solid,
                                size: 28,
                                color: Colors.black,
                              ),
                            );
                          }

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _CollectionQuantityButton(
                                icon: CupertinoIcons.minus,
                                onPressed: () {
                                  Cart.removeOne(cookie);
                                },
                              ),

                              SizedBox(
                                width: 26,
                                child: Text(
                                  '$quantity',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                              ),

                              _CollectionQuantityButton(
                                icon: CupertinoIcons.plus,
                                onPressed: () {
                                  Cart.add(cookie);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionQuantityButton extends StatelessWidget {
  const _CollectionQuantityButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 27,
        height: 27,
        decoration: BoxDecoration(
          color: const Color(0xFFF2EEE9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: const Color(0xFF2D160E)),
      ),
    );
  }
}