import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/cart.dart';
import 'package:flutter_application_1/favorites.dart';
import 'package:flutter_application_1/components/cookie_image.dart';
import 'package:flutter_application_1/components/macro.dart';
import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';
import 'package:flutter_application_1/theme/cookie_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({required this.cookie, super.key});

  final Cookie cookie;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final cookie = widget.cookie;
    final themeColor = cookieThemeColor(cookie.themeColor);

    final unitPrice = cookie.discount > 0 ? cookie.discount : cookie.price;

    final totalPrice = unitPrice * quantity;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      endDrawer: const NaimDrawer(),

      appBar: const NaimAppBar(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: _cardDecoration(30),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Center(
                          child: FractionallySizedBox(
                            widthFactor:
                                (cookie.name == 'Nutella' ||
                                    cookie.name == 'Marzipan' ||
                                    cookie.name == 'Dubai Chocolate' ||
                                    cookie.name == 'Oreo')
                                ? 0.51
                                : 1.0,
                            heightFactor:
                                (cookie.name == 'Nutella' ||
                                    cookie.name == 'Marzipan' ||
                                    cookie.name == 'Dubai Chocolate' ||
                                    cookie.name == 'Oreo')
                                ? 0.51
                                : 1.0,
                            child: CookieImage(
                              picture: cookie.picture,
                              name: cookie.name,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 12,
                      right: 12,
                      child: ValueListenableBuilder<int>(
                        valueListenable: Favorites.changes,
                        builder: (context, _, _) {
                          final isFavorite = Favorites.contains(cookie);

                          return IconButton(
                            onPressed: () {
                              Favorites.toggle(cookie);
                            },
                            icon: Icon(
                              isFavorite
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color: isFavorite
                                  ? const Color(0xFF2D160E)
                                  : Colors.grey.shade600,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: _cardDecoration(30),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cookie.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              cookie.description,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${unitPrice.toStringAsFixed(2)} €',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          if (cookie.discount > 0)
                            Text(
                              '${cookie.price.toStringAsFixed(2)} €',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          cookie.ingredients,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      MyMacroWidget(
                        title: 'Calories',
                        value: cookie.macros.calories,
                        icon: FontAwesomeIcons.fireFlameCurved,
                        iconColor: themeColor,
                      ),

                      const SizedBox(width: 8),

                      MyMacroWidget(
                        title: 'Protein',
                        value: cookie.macros.proteins,
                        icon: FontAwesomeIcons.dumbbell,
                        iconColor: themeColor,
                      ),

                      const SizedBox(width: 8),

                      MyMacroWidget(
                        title: 'Fat',
                        value: cookie.macros.fat,
                        icon: FontAwesomeIcons.droplet,
                        iconColor: themeColor,
                      ),

                      const SizedBox(width: 8),

                      MyMacroWidget(
                        title: 'Carbs',
                        value: cookie.macros.carbs,
                        icon: FontAwesomeIcons.wheatAwn,
                        iconColor: themeColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      const Text(
                        'QUANTITY',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),

                      const Spacer(),

                      _DetailsQuantityButton(
                        icon: CupertinoIcons.minus,
                        onPressed: quantity > 1
                            ? () {
                                setState(() {
                                  quantity--;
                                });
                              }
                            : null,
                      ),

                      const SizedBox(width: 18),

                      SizedBox(
                        width: 24,
                        child: Text(
                          '$quantity',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),

                      const SizedBox(width: 18),

                      _DetailsQuantityButton(
                        icon: CupertinoIcons.plus,
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: FilledButton(
                      onPressed: () {
                        for (int i = 0; i < quantity; i++) {
                          Cart.add(cookie);
                        }

                        setState(() {
                          quantity = 1;
                        });
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        'ADD $quantity TO CART  •  €${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration(double radius) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: const [
        BoxShadow(color: Colors.grey, offset: Offset(3, 3), blurRadius: 5),
      ],
    );
  }
}

class _DetailsQuantityButton extends StatelessWidget {
  const _DetailsQuantityButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: onPressed == null
              ? Colors.grey.shade100
              : const Color(0xFFF2EEE9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: onPressed == null
              ? Colors.grey.shade400
              : const Color(0xFF2D160E),
        ),
      ),
    );
  }
}
