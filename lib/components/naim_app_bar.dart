import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/cart.dart';
import 'package:flutter_application_1/screens/cart/cart_screen.dart';
import 'package:flutter_application_1/components/naim_search_delegate.dart';
import 'package:flutter_application_1/screens/account/account_screen.dart';

class NaimAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NaimAppBar({super.key, this.showBackButton});

  final bool? showBackButton;

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: (showBackButton ?? Navigator.of(context).canPop())
          ? IconButton(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              icon: const Icon(CupertinoIcons.chevron_left, size: 22),
            )
          : null,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      toolbarHeight: 68,

      title: InkWell(
        onTap: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        borderRadius: BorderRadius.circular(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/blueberry-vanilla.png', width: 38, height: 38),
            const SizedBox(width: 2),
            const Text(
              'NAIM',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),

      actions: [
        IconButton(
          onPressed: () {
            showSearch(context: context, delegate: NaimSearchDelegate());
          },
          icon: const Icon(CupertinoIcons.search, size: 22),
        ),

        IconButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const AccountScreen()));
          },
          icon: const Icon(CupertinoIcons.person, size: 22),
        ),

        ValueListenableBuilder<int>(
          valueListenable: Cart.changes,
          builder: (context, _, _) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                  icon: const Icon(CupertinoIcons.cart, size: 23),
                ),

                if (Cart.totalItems > 0)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${Cart.totalItems}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),

        Builder(
          builder: (context) {
            return TextButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text(
                'MENU',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            );
          },
        ),

        const SizedBox(width: 4),
      ],
    );
  }
}
