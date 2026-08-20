import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/cookie_image.dart';
import 'package:flutter_application_1/components/macro.dart';
import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_application_1/theme/cookie_theme.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    required this.cookie,
    super.key,
  });

  final Cookie cookie;

  @override
  Widget build(BuildContext context) {
    final themeColor = cookieThemeColor(cookie.themeColor);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // SAME DRAWER AS HOME
      endDrawer: const NaimDrawer(),

      // SAME HEADER AS HOME
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CookieImage(
                    picture: cookie.picture,
                    name: cookie.name,
                  ),
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
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${cookie.discount.toStringAsFixed(2)} €',
                            style:  TextStyle(
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

                  // INGREDIENTS
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

                  // MACROS
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

                  // BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'ADD TO CART',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
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
        BoxShadow(
          color: Colors.grey,
          offset: Offset(3, 3),
          blurRadius: 5,
        ),
      ],
    );
  }
}