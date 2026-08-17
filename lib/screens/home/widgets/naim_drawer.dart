import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NaimDrawer extends StatelessWidget {
  const NaimDrawer({super.key});

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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                children: [
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

                  const _DrawerSectionTitle(title: 'TODAY'),

                  _DrawerItem(
                    icon: CupertinoIcons.sparkles,
                    title: 'Today\'s Drop',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 18),

                  const _DrawerSectionTitle(title: 'DISCOVER'),

                  _DrawerItem(
                    icon: CupertinoIcons.square_grid_2x2,
                    title: 'The Collection',
                    onTap: () {
                      _openNaimPage(
                        context,
                        title: 'THE COLLECTION',
                        subtitle: 'Our most-loved cookies',
                      );
                    },
                  ),

                  _DrawerItem(
                    icon: CupertinoIcons.heart,
                    title: 'Favorites',
                    onTap: () {
                      _openNaimPage(
                        context,
                        title: 'FAVORITES',
                        subtitle: 'Cookies you love most',
                      );
                    },
                  ),

                  _DrawerItem(
                    icon: CupertinoIcons.photo,
                    title: 'Gallery',
                    onTap: () {
                      _openNaimPage(
                        context,
                        title: 'GALLERY',
                        subtitle: 'A little taste of Naim',
                      );
                    },
                  ),

                  _DrawerItem(
                    icon: CupertinoIcons.book,
                    title: 'Naim Journal',
                    onTap: () {
                      _openNaimPage(
                        context,
                        title: 'NAIM JOURNAL',
                        subtitle: 'Stories, ingredients & inspiration',
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  const _DrawerSectionTitle(title: 'YOUR NAIM'),

                  _DrawerItem(
                    icon: CupertinoIcons.bag,
                    title: 'My Orders',
                    onTap: () {
                      _openNaimPage(
                        context,
                        title: 'MY ORDERS',
                        subtitle: 'Your cookie history',
                      );
                    },
                  ),

                  _DrawerItem(
                    icon: CupertinoIcons.person,
                    title: 'My Account',
                    onTap: () {
                      _openNaimPage(
                        context,
                        title: 'MY ACCOUNT',
                        subtitle: 'Your Naim profile',
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  const _DrawerSectionTitle(title: 'ABOUT'),

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
                        subtitle: 'Small batch. Made with intention.',
                      );
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 6),

                  _DrawerItem(
                    icon: CupertinoIcons.arrow_right_to_line,
                    title: 'Log out',
                    onTap: () {
                      Navigator.pop(context);

                      context
                          .read<SignInBloc>()
                          .add(SignOutRequired());
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