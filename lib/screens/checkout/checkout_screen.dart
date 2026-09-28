import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/cart.dart';
import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final _streetController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController(text: 'Netherlands');

  bool _isLoading = true;
  bool _isPlacingOrder = false;

  String _email = '';

  String _fulfilmentMethod = 'pickup';
  bool _useDefaultAddress = true;
  bool _saveNewAddressAsDefault = true;

  Map<String, dynamic>? _defaultAddress;

  @override
  void initState() {
    super.initState();
    _loadCheckoutData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _streetController.dispose();
    _houseNumberController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _loadCheckoutData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final firestore = FirebaseFirestore.instance;

      final userSnapshot = await firestore
          .collection('users')
          .doc(user.uid)
          .get();

      final data = userSnapshot.data();

      final fullName = data?['name']?.toString().trim() ?? '';

      final storedFirstName = data?['firstName']?.toString().trim() ?? '';

      final storedLastName = data?['lastName']?.toString().trim() ?? '';

      String firstName = storedFirstName;
      String lastName = storedLastName;

      if (firstName.isEmpty && fullName.isNotEmpty) {
        final parts = fullName.split(RegExp(r'\s+'));

        firstName = parts.first;

        if (parts.length > 1) {
          lastName = parts.sublist(1).join(' ');
        }
      }

      final email = data?['email']?.toString().trim() ?? user.email ?? '';

      final addressesSnapshot = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .get();

      Map<String, dynamic>? defaultAddress;

      for (final doc in addressesSnapshot.docs) {
        final address = doc.data();

        if (address['isDefault'] == true) {
          defaultAddress = {...address, 'addressId': doc.id};
          break;
        }
      }

      if (!mounted) return;

      _firstNameController.text = firstName;
      _lastNameController.text = lastName;

      setState(() {
        _email = email;
        _defaultAddress = defaultAddress;
        _isLoading = false;
      });

      if (defaultAddress != null) {
        _fillAddressControllers(defaultAddress);
      }
    } catch (e) {
      debugPrint('CHECKOUT LOAD ERROR: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load checkout details: $e')),
      );
    }
  }

  void _fillAddressControllers(Map<String, dynamic> address) {
    _streetController.text = address['street']?.toString() ?? '';
    _houseNumberController.text = address['houseNumber']?.toString() ?? '';
    _postalCodeController.text = address['postalCode']?.toString() ?? '';
    _cityController.text = address['city']?.toString() ?? '';

    final country = address['country']?.toString() ?? '';

    _countryController.text = country.isNotEmpty ? country : 'Netherlands';
  }

  void _clearAddressControllers() {
    _streetController.clear();
    _houseNumberController.clear();
    _postalCodeController.clear();
    _cityController.clear();
    _countryController.text = 'Netherlands';
  }

  Future<void> _saveAddressAsDefault({required String userId}) async {
    final firestore = FirebaseFirestore.instance;

    final addressesRef = firestore
        .collection('users')
        .doc(userId)
        .collection('addresses');

    final existingAddresses = await addressesRef.get();

    final batch = firestore.batch();

    for (final doc in existingAddresses.docs) {
      if (doc.data()['isDefault'] == true) {
        batch.update(doc.reference, {
          'isDefault': false,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }

    final newAddressRef = addressesRef.doc();

    final newAddress = {
      'street': _streetController.text.trim(),
      'houseNumber': _houseNumberController.text.trim(),
      'postalCode': _postalCodeController.text.trim(),
      'city': _cityController.text.trim(),
      'country': _countryController.text.trim(),
      'isDefault': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    batch.set(newAddressRef, newAddress);

    await batch.commit();

    _defaultAddress = {...newAddress, 'addressId': newAddressRef.id};
  }

  bool _validateCheckout() {
    if (_firstNameController.text.trim().isEmpty) {
      _showError('Please enter your first name.');
      return false;
    }

    if (_lastNameController.text.trim().isEmpty) {
      _showError('Please enter your surname.');
      return false;
    }

    if (_email.trim().isEmpty) {
      _showError('No email address is available for this account.');
      return false;
    }

    if (_fulfilmentMethod == 'delivery') {
      if (_streetController.text.trim().isEmpty ||
          _houseNumberController.text.trim().isEmpty ||
          _postalCodeController.text.trim().isEmpty ||
          _cityController.text.trim().isEmpty ||
          _countryController.text.trim().isEmpty) {
        _showError('Please complete the delivery address.');
        return false;
      }
    }

    if (Cart.items.isEmpty) {
      _showError('Your cart is empty.');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _placeOrder() async {
    if (_isPlacingOrder) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showError('Please sign in before placing an order.');
      return;
    }

    if (!_validateCheckout()) return;

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final customerName = '$firstName $lastName'.trim();

      final uniqueCookies = <dynamic>[];

      for (final cookie in Cart.items) {
        final alreadyAdded = uniqueCookies.any(
          (item) => item.cookieId == cookie.cookieId,
        );

        if (!alreadyAdded) {
          uniqueCookies.add(cookie);
        }
      }

      final orderItems = uniqueCookies.map((cookie) {
        final quantity = Cart.quantityFor(cookie);

        final unitPrice = cookie.discount > 0 ? cookie.discount : cookie.price;

        return {
          'cookieId': cookie.cookieId,
          'name': cookie.name,
          'picture': cookie.picture,
          'quantity': quantity,
          'unitPrice': unitPrice,
          'subtotal': unitPrice * quantity,
        };
      }).toList();

      final firestore = FirebaseFirestore.instance;

      final now = DateTime.now();

      final year = now.year.toString().substring(2);
      final month = now.month.toString().padLeft(2, '0');
      final day = now.day.toString().padLeft(2, '0');

      final dateCode = '$year$month$day';

      final counterRef = firestore.collection('orderCounters').doc(dateCode);

      final orderRef = firestore.collection('orders').doc();

      final dailyDropQuery = await firestore
          .collection('dailyDrops')
          .where('active', isEqualTo: true)
          .limit(1)
          .get();

      DocumentReference<Map<String, dynamic>>? dailyDropRef;

      if (dailyDropQuery.docs.isNotEmpty) {
        dailyDropRef = dailyDropQuery.docs.first.reference;
      }

      final deliveryAddress = _fulfilmentMethod == 'delivery'
          ? {
              'street': _streetController.text.trim(),
              'houseNumber': _houseNumberController.text.trim(),
              'postalCode': _postalCodeController.text.trim(),
              'city': _cityController.text.trim(),
              'country': _countryController.text.trim(),
              'usedDefaultAddress': _useDefaultAddress,
              if (_useDefaultAddress && _defaultAddress?['addressId'] != null)
                'addressId': _defaultAddress!['addressId'],
            }
          : null;

      await firestore.runTransaction((transaction) async {
        final counterSnapshot = await transaction.get(counterRef);

        DocumentSnapshot<Map<String, dynamic>>? dailyDropSnapshot;

        if (dailyDropRef != null) {
          dailyDropSnapshot = await transaction.get(dailyDropRef);
        }

        int nextNumber = 1;

        if (counterSnapshot.exists) {
          final data = counterSnapshot.data();

          final currentNumber = (data?['lastNumber'] as num?)?.toInt() ?? 0;

          nextNumber = currentNumber + 1;
        }

        final sequence = nextNumber.toString().padLeft(3, '0');

        final orderNumber = int.parse('$dateCode$sequence');

        int dailyDropQuantity = 0;

        if (dailyDropSnapshot != null && dailyDropSnapshot.exists) {
          final dropData = dailyDropSnapshot.data();

          final dropCookieId = dropData?['cookieId']?.toString();

          for (final item in orderItems) {
            if (item['cookieId'] == dropCookieId) {
              dailyDropQuantity = (item['quantity'] as num).toInt();
              break;
            }
          }

          if (dailyDropQuantity > 0) {
            final stock = (dropData?['stock'] as num?)?.toInt() ?? 0;

            final sold = (dropData?['sold'] as num?)?.toInt() ?? 0;

            final remaining = stock - sold;

            if (dailyDropQuantity > remaining) {
              throw Exception(
                remaining <= 0
                    ? 'Today\'s Drop has sold out.'
                    : 'Only $remaining Today\'s Drop cookies are left.',
              );
            }
          }
        }

        transaction.set(counterRef, {
          'lastNumber': nextNumber,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        if (dailyDropRef != null && dailyDropQuantity > 0) {
          transaction.update(dailyDropRef, {
            'sold': FieldValue.increment(dailyDropQuantity),
          });
        }

        transaction.set(orderRef, {
          'orderId': orderRef.id,
          'orderNumber': orderNumber,
          'userId': user.uid,

          'customerFirstName': firstName,
          'customerLastName': lastName,
          'customerName': customerName,
          'customerEmail': _email,

          // Kept for backwards compatibility.
          'email': _email,

          'items': orderItems,
          'total': Cart.total,

          'orderStatus': 'pending',
          'paymentStatus': 'unpaid',
          'paymentMethod': 'tikkie',

          'fulfilmentMethod': _fulfilmentMethod,

          if (_fulfilmentMethod == 'pickup') 'pickupLocation': 'Venlo',

          if (_fulfilmentMethod == 'delivery')
            'deliveryAddress': deliveryAddress,

          'createdAt': FieldValue.serverTimestamp(),
        });
      });

      if (_fulfilmentMethod == 'delivery' &&
          !_useDefaultAddress &&
          _saveNewAddressAsDefault) {
        await _saveAddressAsDefault(userId: user.uid);
      }

      Cart.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your Naim order has been created 🍪')),
      );

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not place order: $e')));

      debugPrint('ORDER ERROR: $e');
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
    final authUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),
      body: authUser == null
          ? const Center(
              child: Text(
                'Please sign in to continue with checkout.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            )
          : _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CHECKOUT',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Almost yours.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 28),

                      const _SectionTitle(title: 'YOUR ORDER'),

                      const SizedBox(height: 12),

                      ..._buildOrderItems(),

                      const SizedBox(height: 10),

                      const Divider(),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TOTAL',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            '€${Cart.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2D160E),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      const _SectionTitle(title: 'CONTACT'),

                      const SizedBox(height: 12),

                      _InfoCard(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _CheckoutField(
                                  label: 'First name',
                                  controller: _firstNameController,
                                  hintText: 'First name',
                                  textCapitalization: TextCapitalization.words,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _CheckoutField(
                                  label: 'Surname',
                                  controller: _lastNameController,
                                  hintText: 'Surname',
                                  textCapitalization: TextCapitalization.words,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          const _MiniLabel(text: 'EMAIL'),

                          const SizedBox(height: 8),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F5F3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              _email.isNotEmpty ? _email : 'Not available',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      const _SectionTitle(title: 'FULFILMENT'),

                      const SizedBox(height: 12),

                      _InfoCard(
                        children: [
                          _ChoiceTile(
                            title: 'Pickup',
                            subtitle: 'Collect your order in Venlo',
                            selected: _fulfilmentMethod == 'pickup',
                            onTap: () {
                              setState(() {
                                _fulfilmentMethod = 'pickup';
                              });
                            },
                          ),

                          const SizedBox(height: 10),

                          _ChoiceTile(
                            title: 'Delivery',
                            subtitle: 'Have your order delivered',
                            selected: _fulfilmentMethod == 'delivery',
                            onTap: () {
                              setState(() {
                                _fulfilmentMethod = 'delivery';
                              });
                            },
                          ),
                        ],
                      ),

                      if (_fulfilmentMethod == 'pickup') ...[
                        const SizedBox(height: 18),

                        const _InfoCard(
                          children: [
                            _InfoRow(label: 'Method', value: 'Pickup'),
                            SizedBox(height: 14),
                            _InfoRow(label: 'Location', value: 'Venlo'),
                          ],
                        ),
                      ],

                      if (_fulfilmentMethod == 'delivery') ...[
                        const SizedBox(height: 18),

                        _InfoCard(
                          children: [
                            _ChoiceTile(
                              title: 'Use my default address',
                              subtitle: _defaultAddress != null
                                  ? _formatAddress(_defaultAddress!)
                                  : 'No default address saved',
                              selected: _useDefaultAddress,
                              enabled: _defaultAddress != null,
                              onTap: () {
                                if (_defaultAddress == null) {
                                  return;
                                }

                                _fillAddressControllers(_defaultAddress!);

                                setState(() {
                                  _useDefaultAddress = true;
                                });
                              },
                            ),

                            const SizedBox(height: 10),

                            _ChoiceTile(
                              title: 'Enter another address',
                              subtitle:
                                  'Use a different address for this order',
                              selected: !_useDefaultAddress,
                              onTap: () {
                                if (_useDefaultAddress) {
                                  _clearAddressControllers();
                                }

                                setState(() {
                                  _useDefaultAddress = false;
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        _InfoCard(
                          children: [
                            _CheckoutField(
                              label: 'Street',
                              controller: _streetController,
                              hintText: 'Street',
                              enabled: !_useDefaultAddress,
                              textCapitalization: TextCapitalization.words,
                            ),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _CheckoutField(
                                    label: 'House number',
                                    controller: _houseNumberController,
                                    hintText: '12A',
                                    enabled: !_useDefaultAddress,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 3,
                                  child: _CheckoutField(
                                    label: 'Postcode',
                                    controller: _postalCodeController,
                                    hintText: '5911 AA',
                                    enabled: !_useDefaultAddress,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            _CheckoutField(
                              label: 'City',
                              controller: _cityController,
                              hintText: 'Venlo',
                              enabled: !_useDefaultAddress,
                              textCapitalization: TextCapitalization.words,
                            ),

                            const SizedBox(height: 16),

                            _CheckoutField(
                              label: 'Country',
                              controller: _countryController,
                              hintText: 'Netherlands',
                              enabled: !_useDefaultAddress,
                              textCapitalization: TextCapitalization.words,
                            ),

                            if (!_useDefaultAddress) ...[
                              const SizedBox(height: 16),

                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _saveNewAddressAsDefault =
                                        !_saveNewAddressAsDefault;
                                  });
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: _saveNewAddressAsDefault,
                                        activeColor: Colors.black,
                                        onChanged: (value) {
                                          setState(() {
                                            _saveNewAddressAsDefault =
                                                value ?? true;
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 4),
                                      const Expanded(
                                        child: Text(
                                          'Save this as my default address',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],

                      const SizedBox(height: 28),

                      const _SectionTitle(title: 'PAYMENT'),

                      const SizedBox(height: 12),

                      const _InfoCard(
                        children: [
                          _InfoRow(label: 'Method', value: 'Tikkie'),
                          SizedBox(height: 6),
                          Text(
                            'Tikkie payment connection will be added next.',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: _isPlacingOrder ? null : _placeOrder,
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isPlacingOrder
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'PLACE ORDER  •  €${Cart.total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
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

  List<Widget> _buildOrderItems() {
    final uniqueCookies = <dynamic>[];

    for (final cookie in Cart.items) {
      final alreadyAdded = uniqueCookies.any(
        (item) => item.cookieId == cookie.cookieId,
      );

      if (!alreadyAdded) {
        uniqueCookies.add(cookie);
      }
    }

    return uniqueCookies.map<Widget>((cookie) {
      final quantity = Cart.quantityFor(cookie);

      final unitPrice = cookie.discount > 0 ? cookie.discount : cookie.price;

      final subtotal = unitPrice * quantity;

      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                cookie.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              '× $quantity',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 18),
            Text(
              '€${subtotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _formatAddress(Map<String, dynamic> address) {
    final street = address['street']?.toString().trim() ?? '';
    final houseNumber = address['houseNumber']?.toString().trim() ?? '';
    final postalCode = address['postalCode']?.toString().trim() ?? '';
    final city = address['city']?.toString().trim() ?? '';

    final firstLine = '$street $houseNumber'.trim();
    final secondLine = '$postalCode $city'.trim();

    return [firstLine, secondLine].where((line) => line.isNotEmpty).join(' • ');
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.3,
        color: Colors.grey.shade500,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MiniLabel(text: label.toUpperCase()),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _MiniLabel extends StatelessWidget {
  const _MiniLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 1,
        color: Colors.grey.shade500,
      ),
    );
  }
}

class _CheckoutField extends StatelessWidget {
  const _CheckoutField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final bool enabled;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MiniLabel(text: label.toUpperCase()),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: const Color(0xFFF7F5F3),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F5F3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Colors.black : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: enabled ? Colors.black : Colors.grey.shade400,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: enabled ? Colors.black : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: enabled
                          ? Colors.grey.shade600
                          : Colors.grey.shade400,
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
}
