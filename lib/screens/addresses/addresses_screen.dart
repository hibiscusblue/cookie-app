import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';
import 'package:flutter_application_1/screens/addresses/add_address_screen.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MY ADDRESSES',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Manage your delivery and billing addresses.',
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 30),

                  if (user == null)
                    const Center(
                      child: Text(
                        'Please sign in to view your addresses.',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    )
                  else
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('addresses')
                          .orderBy('createdAt')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              'Unable to load your addresses.',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          );
                        }

                        final addresses = snapshot.data?.docs ?? [];

                        if (addresses.isEmpty) {
                          return _EmptyAddressesCard(
                            onAddAddress: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AddAddressScreen(),
                                ),
                              );
                            },
                          );
                        }

                        return Column(
                          children: [
                            ...addresses.map((document) {
                              final data = document.data();

                              final fullName =
                                  data['fullName']?.toString() ?? '';

                              final street = data['street']?.toString() ?? '';

                              final houseNumber =
                                  data['houseNumber']?.toString() ?? '';

                              final postalCode =
                                  data['postalCode']?.toString() ?? '';

                              final city = data['city']?.toString() ?? '';

                              final country = data['country']?.toString() ?? '';

                              final isDefault = data['isDefault'] == true;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _AddressCard(
                                  fullName: fullName,
                                  street: street,
                                  houseNumber: houseNumber,
                                  postalCode: postalCode,
                                  city: city,
                                  country: country,
                                  isDefault: isDefault,
                                  onMakeDefault: () async {
                                    final addressesRef = FirebaseFirestore
                                        .instance
                                        .collection('users')
                                        .doc(user.uid)
                                        .collection('addresses');

                                    final allAddresses = await addressesRef
                                        .get();

                                    final batch = FirebaseFirestore.instance
                                        .batch();

                                    for (final address in allAddresses.docs) {
                                      batch.update(address.reference, {
                                        'isDefault': address.id == document.id,
                                      });
                                    }

                                    await batch.commit();
                                  },
                                ),
                              );
                            }),

                            const SizedBox(height: 8),

                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const AddAddressScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add),
                                label: const Text(
                                  'ADD ANOTHER ADDRESS',
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: const BorderSide(color: Colors.black),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.fullName,
    required this.street,
    required this.houseNumber,
    required this.postalCode,
    required this.city,
    required this.country,
    required this.isDefault,
    required this.onMakeDefault,
  });

  final String fullName;
  final String street;
  final String houseNumber;
  final String postalCode;
  final String city;
  final String country;
  final bool isDefault;
  final VoidCallback onMakeDefault;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2EEE9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF2D160E),
                ),
              ),

              const Spacer(),

              if (isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'DEFAULT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            fullName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),

          const SizedBox(height: 10),

          Text('$street $houseNumber', style: const TextStyle(fontSize: 15)),

          const SizedBox(height: 4),

          Text('$postalCode $city', style: const TextStyle(fontSize: 15)),

          const SizedBox(height: 4),

          Text(
            country,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),

          if (!isDefault) ...[
            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onMakeDefault,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'MAKE DEFAULT',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyAddressesCard extends StatelessWidget {
  const _EmptyAddressesCard({required this.onAddAddress});

  final VoidCallback onAddAddress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 42,
            color: Color(0xFF2D160E),
          ),

          const SizedBox(height: 14),

          const Text(
            'No addresses yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),

          const SizedBox(height: 6),

          Text(
            'Add an address for faster checkout.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onAddAddress,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'ADD ADDRESS',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
