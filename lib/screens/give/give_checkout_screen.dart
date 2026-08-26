import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';

class GiveCheckoutScreen extends StatefulWidget {
  const GiveCheckoutScreen({
    super.key,
    required this.selectedCookies,
    required this.chefChoiceCount,
    required this.totalPrice,
  });

  final Map<String, int> selectedCookies;
  final int chefChoiceCount;
  final double totalPrice;

  @override
  State<GiveCheckoutScreen> createState() =>
      _GiveCheckoutScreenState();
}

class _GiveCheckoutScreenState extends State<GiveCheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _noteController = TextEditingController();

  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _streetController.dispose();
    _houseNumberController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _noteController.dispose();

    super.dispose();
  }

  Future<void> _placeGiftOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in first.'),
        ),
      );
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('giveOrders')
          .add({
        'userId': user.uid,

        'selectedCookies':
            Map<String, int>.from(widget.selectedCookies),

        'chefChoiceCount': widget.chefChoiceCount,

        'totalPrice': widget.totalPrice,

        'deliveryAddress': {
          'fullName': _fullNameController.text.trim(),
          'street': _streetController.text.trim(),
          'houseNumber':
              _houseNumberController.text.trim(),
          'postalCode':
              _postalCodeController.text.trim(),
          'city': _cityController.text.trim(),
          'country': _countryController.text.trim(),
        },

        'personalNote': _noteController.text.trim(),

        'type': 'charity',
        'status': 'pending',

        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const GiveSuccessScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not place gift order: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.surface,

      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),

      body: Form(
        key: _formKey,

        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            24,
            18,
            24,
            40,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              const Text(
                'GIFT CHECKOUT',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Tell us where this little moment of bliss should go.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 30),

              // ===========================================================
              // DELIVERY ADDRESS
              // ===========================================================

              const Text(
                'DELIVERY ADDRESS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 14),

              _CheckoutField(
                controller: _fullNameController,
                label: 'RECIPIENT NAME',
                hint: 'Who should receive the gift?',
              ),

              const SizedBox(height: 16),

              _CheckoutField(
                controller: _streetController,
                label: 'STREET',
                hint: 'Street name',
              ),

              const SizedBox(height: 16),

              _CheckoutField(
                controller:
                    _houseNumberController,
                label: 'HOUSE NUMBER',
                hint: 'House number',
              ),

              const SizedBox(height: 16),

              _CheckoutField(
                controller:
                    _postalCodeController,
                label: 'POSTAL CODE',
                hint: 'Postal code',
              ),

              const SizedBox(height: 16),

              _CheckoutField(
                controller: _cityController,
                label: 'CITY',
                hint: 'City',
              ),

              const SizedBox(height: 16),

              _CheckoutField(
                controller: _countryController,
                label: 'COUNTRY',
                hint: 'Country',
              ),

              const SizedBox(height: 32),

              // ===========================================================
              // PERSONAL NOTE
              // ===========================================================

              const Text(
                'PERSONAL NOTE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Optional',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _noteController,
                maxLines: 5,
                maxLength: 200,

                decoration: InputDecoration(
                  hintText:
                      'Write something kind for them...',

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),

                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                  ),

                  contentPadding:
                      const EdgeInsets.all(18),
                ),
              ),

              const SizedBox(height: 22),

              // ===========================================================
              // ORDER TOTAL
              // ===========================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(24),
                ),

                child: Row(
                  children: [
                    const Text(
                      'TOTAL',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      '€${widget.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: const Color(0xFFF2EEE9),
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: const Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Icon(
                      Icons.favorite_outline,
                      color: Color(0xFF2D160E),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        'Your personal note can be included with the cookies so the recipient knows someone was thinking of them.',
                        style: TextStyle(
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ===========================================================
              // PLACE ORDER
              // ===========================================================

              SizedBox(
                width: double.infinity,

                child: FilledButton(
                  onPressed:
                      _isPlacingOrder
                          ? null
                          : _placeGiftOrder,

                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,

                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 17,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                  ),

                  child: _isPlacingOrder
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'PLACE GIFT ORDER',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================================
// CHECKOUT FIELD
// ==========================================================================

class _CheckoutField extends StatelessWidget {
  const _CheckoutField({
    required this.controller,
    required this.label,
    required this.hint,
  });

  final TextEditingController controller;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color: Colors.grey.shade600,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,

          validator: (value) {
            if (value == null ||
                value.trim().isEmpty) {
              return 'Please enter this information';
            }

            return null;
          },

          decoration: InputDecoration(
            hintText: hint,

            filled: true,
            fillColor: Colors.white,

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 1.5,
              ),
            ),

            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 17,
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================================================
// SUCCESS SCREEN
// ==========================================================================

class GiveSuccessScreen extends StatelessWidget {
  const GiveSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.surface,

      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(28),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                const Icon(
                  Icons.favorite,
                  size: 52,
                  color: Color(0xFF2D160E),
                ),

                const SizedBox(height: 20),

                const Text(
                  'YOU GAVE A MOMENT OF BLISS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Thank you for choosing to share a Naim cookie with someone else.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color:
                        Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,

                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context)
                          .popUntil(
                        (route) =>
                            route.isFirst,
                      );
                    },

                    style:
                        FilledButton.styleFrom(
                      backgroundColor:
                          Colors.black,
                      foregroundColor:
                          Colors.white,
                      padding:
                          const EdgeInsets
                              .symmetric(
                        vertical: 16,
                      ),
                    ),

                    child: const Text(
                      'BACK TO NAIM',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}