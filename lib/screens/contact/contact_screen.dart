import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/components/naim_footer.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _marketingConsent = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      _emailController.text = user.email ?? '';
      _nameController.text = user.displayName ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();

    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      final name = _nameController.text.trim();
      final email = _emailController.text.trim().toLowerCase();
      final subject = _subjectController.text.trim();
      final message = _messageController.text.trim();

      await FirebaseFirestore.instance.collection('contactMessages').add({
        'name': name,
        'email': email,
        'subject': subject,
        'message': message,
        'userId': user?.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'new',
      });

      if (_marketingConsent) {
        await FirebaseFirestore.instance
            .collection('subscribers')
            .doc(email)
            .set({
          'email': email,
          'name': name,
          'userId': user?.uid,
          'source': 'contactForm',
          'marketingConsent': true,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      if (!mounted) return;

      _subjectController.clear();
      _messageController.clear();

      setState(() {
        _marketingConsent = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your message has been sent ♡',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                24,
                20,
                32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CONTACT',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'We would love to hear from you.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 32),

                  const _ContactCard(
                    icon: Icons.email_outlined,
                    title: 'EMAIL',
                    value: 'hello@naimcookies.com',
                  ),

                  const SizedBox(height: 14),

                  // const _ContactCard(
                  //   icon: Icons.location_on_outlined,
                  //   title: 'LOCATION',
                  //   value: 'Venlo, The Netherlands',
                  // ),

                  // const SizedBox(height: 14),

                  const _ContactCard(
                    icon: Icons.schedule_outlined,
                    title: 'RESPONSE TIME',
                    value: 'Usually within 1–2 business days',
                  ),

                  const SizedBox(height: 36),

                  const Text(
                    'SEND US A MESSAGE',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.4,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Questions, collaborations, orders or just a little hello.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _NaimTextField(
                          controller: _nameController,
                          label: 'NAME',
                          hint: 'Your name',
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Please enter your name';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        _NaimTextField(
                          controller: _emailController,
                          label: 'EMAIL',
                          hint: 'you@example.com',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            final email =
                                value?.trim() ?? '';

                            if (email.isEmpty) {
                              return 'Please enter your email';
                            }

                            if (!email.contains('@') ||
                                !email.contains('.')) {
                              return 'Please enter a valid email';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        _NaimTextField(
                          controller: _subjectController,
                          label: 'SUBJECT',
                          hint: 'What can we help you with?',
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Please enter a subject';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        _NaimTextField(
                          controller: _messageController,
                          label: 'MESSAGE',
                          hint: 'Write your message here...',
                          maxLines: 6,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Please write a message';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            setState(() {
                              _marketingConsent =
                                  !_marketingConsent;
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 6,
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _marketingConsent,
                                  activeColor:
                                      const Color(0xFF2D160E),
                                  onChanged: (value) {
                                    setState(() {
                                      _marketingConsent =
                                          value ?? false;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Text(
                                      'Keep me updated with Naim drops, '
                                      'new flavours and little surprises.',
                                      style: TextStyle(
                                        fontSize: 13,
                                        height: 1.4,
                                        color:
                                            Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed:
                                _isSending ? null : _sendMessage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  Colors.black54,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(18),
                              ),
                            ),
                            child: _isSending
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'SEND MESSAGE',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                          FontWeight.w900,
                                      letterSpacing: 1,
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

            const NaimFooter(),
          ],
        ),
      ),
    );
  }
}

class _NaimTextField extends StatelessWidget {
  const _NaimTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color: Colors.grey.shade600,
          ),
        ),

        const SizedBox(height: 7),

        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 17,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: Color(0xFF2D160E),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: Colors.redAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFF7F4F1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 21,
              color: const Color(0xFF2D160E),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                    color: Colors.grey.shade500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}