import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),

      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MY ACCOUNT',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),

                const SizedBox(height: 24),

                // =================================================
                // USER CARD
                // =================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xFFF2EEE9),
                        child: Text(
                          _initialFor(user),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2D160E),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _welcomeText(user),
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              user?.email ?? 'Your Naim account',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // =================================================
                // ACCOUNT OPTIONS
                // =================================================

                _AccountTile(
                  icon: Icons.receipt_long_outlined,
                  title: 'My Orders',
                  subtitle: 'View your previous orders',
                  onTap: () {
                    // We will connect this next.
                  },
                ),

                _AccountTile(
                  icon: Icons.favorite_border,
                  title: 'Favorites',
                  subtitle: 'Your saved cookies',
                  onTap: () {
                    // Connect to Favorites screen later.
                  },
                ),

                _AccountTile(
                  icon: Icons.location_on_outlined,
                  title: 'Addresses',
                  subtitle: 'Delivery and billing addresses',
                  onTap: () {
                    // Connect address screen later.
                  },
                ),

                _AccountTile(
                  icon: Icons.person_outline,
                  title: 'Personal Details',
                  subtitle: 'Name, email and account information',
                  onTap: () {
                    _showPersonalDetails(
                      context,
                      user,
                    );
                  },
                ),

                const SizedBox(height: 20),

                // =================================================
                // LOG OUT
                // =================================================

                _AccountTile(
                  icon: Icons.logout,
                  title: 'Log out',
                  subtitle: 'Sign out of your Naim account',
                  onTap: () {
                    _logOut(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // =============================================================
  // USER NAME
  // =============================================================

  String _welcomeText(User? user) {
    if (user == null) {
      return 'Welcome to Naim';
    }

    final displayName = user.displayName?.trim();

    if (displayName != null && displayName.isNotEmpty) {
      return 'Welcome, $displayName';
    }

    final email = user.email;

    if (email != null && email.contains('@')) {
      final name = email.split('@').first;

      if (name.isNotEmpty) {
        return 'Welcome, ${_capitalize(name)}';
      }
    }

    return 'Welcome to Naim';
  }

  // =============================================================
  // PROFILE INITIAL
  // =============================================================

  String _initialFor(User? user) {
    final displayName = user?.displayName?.trim();

    if (displayName != null && displayName.isNotEmpty) {
      return displayName[0].toUpperCase();
    }

    final email = user?.email;

    if (email != null && email.isNotEmpty) {
      return email[0].toUpperCase();
    }

    return 'N';
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() + value.substring(1);
  }

  // =============================================================
  // PERSONAL DETAILS
  // =============================================================

  void _showPersonalDetails(
    BuildContext context,
    User? user,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 34),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PERSONAL DETAILS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 24),

              _DetailRow(
                title: 'Name',
                value: user?.displayName?.isNotEmpty == true
                    ? user!.displayName!
                    : 'Not added yet',
              ),

              const SizedBox(height: 18),

              _DetailRow(
                title: 'Email',
                value: user?.email ?? 'Not available',
              ),
            ],
          ),
        );
      },
    );
  }

  // =============================================================
  // LOG OUT
  // =============================================================

  Future<void> _logOut(BuildContext context) async {
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

    if (shouldLogout != true) {
      return;
    }

    await FirebaseAuth.instance.signOut();

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).popUntil(
      (route) => route.isFirst,
    );
  }
}

// ===============================================================
// ACCOUNT TILE
// ===============================================================

class _AccountTile extends StatelessWidget {
  const _AccountTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2EEE9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF2D160E),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===============================================================
// PERSONAL DETAIL ROW
// ===============================================================

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color: Colors.grey.shade500,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}