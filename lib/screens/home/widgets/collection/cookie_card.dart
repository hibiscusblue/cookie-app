import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/screens/home/blocs/get_cookie_bloc/get_cookie_bloc.dart';
import 'package:flutter_application_1/cart.dart';
import 'package:flutter_application_1/components/cookie_badge.dart';
import 'package:flutter_application_1/components/cookie_image.dart';
import 'package:flutter_application_1/screens/home/views/details_screen.dart';
import 'package:flutter_application_1/theme/label_colors.dart';
import 'package:flutter_application_1/favorites.dart';

class CookieCard extends StatelessWidget {
  const CookieCard({super.key, required this.cookie});

  final Cookie cookie;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      color: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          final getCookieBloc = context.read<GetCookieBloc>();

          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => BlocProvider.value(
                value: getCookieBloc,
                child: DetailsScreen(cookie: cookie),
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox.expand(
                      child: Center(
                        child: FractionallySizedBox(
                             widthFactor:
                                (cookie.name == 'Nutella' ||
                                    cookie.name == 'Marzipan' ||
                                    // cookie.name == 'Dubai Chocolate' ||
                                    cookie.name == 'Oreo')
                                ? 0.51
                                : 1.0,
                            heightFactor:
                                (cookie.name == 'Nutella' ||
                                    cookie.name == 'Marzipan' ||
                                    // cookie.name == 'Dubai Chocolate' ||
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
                    top: 8,
                    right: 8,
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
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  Text(
                    cookie.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

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
        decoration: const BoxDecoration(
          color: Color(0xFFF2EEE9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: Color(0xFF2D160E)),
      ),
    );
  }
}
