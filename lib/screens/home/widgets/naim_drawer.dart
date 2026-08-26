import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/screens/account/account_screen.dart';
import 'package:flutter_application_1/screens/give/give_screen.dart';
import 'package:flutter_application_1/screens/home/views/collection_screen.dart';
import 'package:flutter_application_1/screens/home/views/favorites_screen.dart';
import 'package:flutter_application_1/screens/home/views/todays_drop_screen.dart';
import 'package:flutter_application_1/screens/journal/journal_screen.dart';
import 'package:flutter_application_1/screens/orders/orders_screen.dart';

class NaimDrawer extends StatelessWidget {
  const NaimDrawer({super.key});

  // =========================================================================
  // LOG OUT
  // =========================================================================

  Future<void> _logOut(BuildContext context) async {
    // Close the drawer first.
    Navigator.pop(context);

    // Ask the user for confirmation.
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Log out?',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out of your Naim account?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'LOG OUT',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );

    // User pressed Cancel or closed the popup.
    if (shouldLogout != true) {
      return;
    }

    // Actually log the user out of Firebase.
    await FirebaseAuth.instance.signOut();

    if (!context.mounted) {
      return;
    }

    // Return to the first screen.
    Navigator.of(context).popUntil(
      (route) => route.isFirst,
    );
  }

  // =========================================================================
  // DRAWER
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF8F8F8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // =================================================================
            // MAIN MENU
            // =================================================================

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  22,
                  20,
                  20,
                ),
                children: [
                  // ===========================================================
                  // NAIM HEADER
                  // ===========================================================

                  Row(
                    children: [
                      Image.asset(
                        'assets/blueberry-vanilla.png',
                        width: 52,
                        height: 52,
                      ),

                      const SizedBox(width: 12),

                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NAIM',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'Your Moment of Bliss',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ===========================================================
                  // TODAY
                  // ===========================================================

                  const _DrawerSectionTitle(
                    title: 'TODAY',
                  ),

                  _DrawerItem(
                    icon: CupertinoIcons.sparkles,
                    title: 'Today\'s Drop',
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const TodaysDropScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  // ===========================================================
                  // DISCOVER
                  // ===========================================================

                  const _DrawerSectionTitle(
                    title: 'DISCOVER',
                  ),

                  _DrawerItem(
                    icon: CupertinoIcons.square_grid_2x2,
                    title: 'The Collection',
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const CollectionScreen(),
                        ),
                      );
                    },
                  ),

                  _DrawerItem(
                    icon: CupertinoIcons.heart,
                    title: 'Favorites',
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const FavoritesScreen(),
                        ),
                      );
                    },
                  ),

                  _DrawerItem(
                    icon: CupertinoIcons.book,
                    title: 'Naim Journal',
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const JournalScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  // ===========================================================
                  // YOUR NAIM
                  // ===========================================================

                  const _DrawerSectionTitle(
                    title: 'YOUR NAIM',
                  ),

                  _DrawerItem(
                    icon: CupertinoIcons.bag,
                    title: 'My Orders',
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const OrdersScreen(),
                        ),
                      );
                    },
                  ),

                  _DrawerItem(
                    icon: CupertinoIcons.person,
                    title: 'My Account',
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const AccountScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  // ===========================================================
                  // GIVE
                  // ===========================================================

                  const _DrawerSectionTitle(
                    title: 'GIVE',
                  ),

                  _DrawerItem(
                    icon: CupertinoIcons.gift,
                    title: 'Give',
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const GiveScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  // ===========================================================
                  // ABOUT
                  // ===========================================================

                  const _DrawerSectionTitle(
                    title: 'ABOUT',
                  ),

                  _DrawerItem(
                    icon: CupertinoIcons.heart_fill,
                    title: 'Our Story',
                    onTap: () {
                      _openNaimPage(
                        context,
                        title: 'OUR STORY',
                        subtitle: 'Why Naim exists',
                      );
                    },
                  ),

                  _DrawerItem(
                    icon: CupertinoIcons.info_circle,
                    title: 'About Naim',
                    onTap: () {
                      _openNaimPage(
                        context,
                        title: 'ABOUT NAIM',
                        subtitle:
                            'Small batch. Made with intention.',
                      );
                    },
                  ),
                ],
              ),
            ),

            // =================================================================
            // LOG OUT
            // =================================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                18,
              ),
              child: Column(
                children: [
                  const Divider(),

                  const SizedBox(height: 6),

                  _DrawerItem(
                    icon:
                        CupertinoIcons.arrow_right_to_line,
                    title: 'Log out',
                    onTap: () {
                      _logOut(context);
                    },
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

// ============================================================================
// SECTION TITLE
// ============================================================================

class _DrawerSectionTitle extends StatelessWidget {
  const _DrawerSectionTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        bottom: 7,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.4,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }
}

// ============================================================================
// DRAWER ITEM
// ============================================================================

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      minLeadingWidth: 48,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      leading: Icon(
        icon,
        size: 21,
        color: const Color(0xFF2D160E),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: const Icon(
        CupertinoIcons.chevron_right,
        size: 14,
      ),
      onTap: onTap,
    );
  }
}

// ============================================================================
// SIMPLE NAIM PAGE
// ============================================================================

void _openNaimPage(
  BuildContext context, {
  required String title,
  required String subtitle,
}) {
  Navigator.pop(context);

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => _NaimPage(
        title: title,
        subtitle: subtitle,
      ),
    ),
  );
}

class _NaimPage extends StatelessWidget {
  const _NaimPage({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              subtitle,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 40),

            const Center(
              child: Text(
                'Coming soon 🍪',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}