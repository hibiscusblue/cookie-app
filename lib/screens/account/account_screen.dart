import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/orders/orders_screen.dart';
import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';
import 'package:flutter_application_1/screens/home/views/favorites_screen.dart';
import 'package:flutter_application_1/screens/addresses/addresses_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),

      body: authUser == null
          ? const Center(
              child: Text(
                'Please sign in to view your account.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            )
          : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(authUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Unable to load your account.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }

                final data = snapshot.data?.data();

                final name = data?['name']?.toString().trim() ?? '';

                final email =
                    data?['email']?.toString().trim() ?? authUser.email ?? '';

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                _initialFor(name),
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
                                    name.isNotEmpty
                                        ? 'Welcome, $name'
                                        : 'Welcome to Naim',
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    email.isNotEmpty
                                        ? email
                                        : 'Your Naim account',
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const OrdersScreen(),
                            ),
                          );
                        },
                      ),
                      _AccountTile(
                        icon: Icons.favorite_border,
                        title: 'Favorites',
                        subtitle: 'Your saved cookies',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const FavoritesScreen(),
                            ),
                          );
                        },
                      ),

                      _AccountTile(
                        icon: Icons.location_on_outlined,
                        title: 'Addresses',
                        subtitle: 'Delivery and billing addresses',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AddressesScreen(),
                            ),
                          );
                        },
                      ),

                      _AccountTile(
                        icon: Icons.person_outline,
                        title: 'Personal Details',
                        subtitle: 'Name, email and account information',
                        onTap: () {
                          _showPersonalDetails(
                            context,
                            userId: authUser.uid,
                            name: name,
                            email: email,
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
  // PROFILE INITIAL
  // =============================================================

  String _initialFor(String name) {
    final cleanName = name.trim();

    if (cleanName.isNotEmpty) {
      return cleanName[0].toUpperCase();
    }

    return 'N';
  }

  // =============================================================
  // PERSONAL DETAILS
  // =============================================================

  void _showPersonalDetails(
    BuildContext context, {
    required String userId,
    required String name,
    required String email,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 34),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Little drag handle
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'PERSONAL DETAILS',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),

                const SizedBox(height: 24),

                // ===========================================================
                // PROFILE
                // ===========================================================
                Row(
                  children: [
                    CircleAvatar(
                      radius: 29,
                      backgroundColor: const Color(0xFFF2EEE9),
                      child: Text(
                        _initialFor(name),
                        style: const TextStyle(
                          fontSize: 21,
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
                            name.isNotEmpty ? name : 'Naim customer',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            email,
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

                const SizedBox(height: 28),

                Divider(color: Colors.grey.shade200),

                const SizedBox(height: 22),

                // ===========================================================
                // DEFAULT ADDRESS
                // ===========================================================
                Row(
                  children: [
                    Text(
                      'DEFAULT DELIVERY ADDRESS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('addresses')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                      );
                    }

                    final addresses = snapshot.data?.docs ?? [];

                    QueryDocumentSnapshot<Map<String, dynamic>>? defaultAddress;

                    for (final address in addresses) {
                      if (address.data()['isDefault'] == true) {
                        defaultAddress = address;
                        break;
                      }
                    }

                    if (defaultAddress == null) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F5F3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFF2D160E),
                            ),

                            const SizedBox(width: 12),

                            Text(
                              'No default address selected',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      );
                    }

                    final data = defaultAddress.data();

                    final street = data['street']?.toString() ?? '';

                    final houseNumber = data['houseNumber']?.toString() ?? '';

                    final postalCode = data['postalCode']?.toString() ?? '';

                    final city = data['city']?.toString() ?? '';

                    final country = data['country']?.toString() ?? '';

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F5F3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFF2D160E),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$street $houseNumber',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  '$postalCode $city',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),

                                const SizedBox(height: 2),

                                Text(
                                  country,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'DEFAULT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddressesScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'MANAGE ADDRESSES',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
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
            style: TextStyle(fontWeight: FontWeight.w900),
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
                style: TextStyle(fontWeight: FontWeight.w800),
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

    Navigator.of(context).popUntil((route) => route.isFirst);
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
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2EEE9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: const Color(0xFF2D160E)),
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

                const Icon(Icons.chevron_right, size: 20),
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
  const _DetailRow({required this.title, required this.value});

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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
