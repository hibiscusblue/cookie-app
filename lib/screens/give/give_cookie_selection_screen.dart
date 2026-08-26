import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/give/give_summary_screen.dart';
import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';

class GiveCookieSelectionScreen extends StatefulWidget {
  const GiveCookieSelectionScreen({super.key, required this.quantity});

  final int quantity;

  @override
  State<GiveCookieSelectionScreen> createState() =>
      _GiveCookieSelectionScreenState();
}

class _GiveCookieSelectionScreenState extends State<GiveCookieSelectionScreen> {
  final Map<String, int> selectedCookies = {};

  int chefChoiceCount = 0;

  int get totalSelected {
    int total = chefChoiceCount;

    for (final count in selectedCookies.values) {
      total += count;
    }

    return total;
  }

  bool get selectionComplete {
    return totalSelected == widget.quantity;
  }

  void _addCookie(String cookieId) {
    if (totalSelected >= widget.quantity) {
      return;
    }

    setState(() {
      selectedCookies[cookieId] = (selectedCookies[cookieId] ?? 0) + 1;
    });
  }

  void _removeCookie(String cookieId) {
    final currentCount = selectedCookies[cookieId] ?? 0;

    if (currentCount <= 0) {
      return;
    }

    setState(() {
      if (currentCount == 1) {
        selectedCookies.remove(cookieId);
      } else {
        selectedCookies[cookieId] = currentCount - 1;
      }
    });
  }

  void _addChefChoice() {
    if (totalSelected >= widget.quantity) {
      return;
    }

    setState(() {
      chefChoiceCount++;
    });
  }

  void _removeChefChoice() {
    if (chefChoiceCount <= 0) {
      return;
    }

    setState(() {
      chefChoiceCount--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('cookies').snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Unable to load cookies.',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            );
          }

          final cookies = snapshot.data?.docs ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 40),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CHOOSE YOUR COOKIES',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                ),

                const SizedBox(height: 8),

                Text(
                  widget.quantity == 1
                      ? 'Choose 1 cookie to give.'
                      : 'Choose ${widget.quantity} cookies to give. Mix flavours or let Naim choose.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 22),

                // =========================================================
                // SELECTION COUNTER
                // =========================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Row(
                    children: [
                      const Icon(
                        Icons.favorite_outline,
                        color: Color(0xFF2D160E),
                      ),

                      const SizedBox(width: 12),

                      const Text(
                        'Selected',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),

                      const Spacer(),

                      Text(
                        '$totalSelected / ${widget.quantity}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // =========================================================
                // CHEF'S CHOICE
                // =========================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2EEE9),
                    borderRadius: BorderRadius.circular(24),
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: const Icon(
                          Icons.auto_awesome,
                          size: 30,
                          color: Color(0xFF2D160E),
                        ),
                      ),

                      const SizedBox(width: 16),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chef\'s Choice',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),

                            SizedBox(height: 4),

                            // Text(
                            //   'Picked by the chef herself.',
                            //   style: TextStyle(
                            //     fontSize: 13,
                            //     color: Colors.grey,
                            //   ),
                            // ),
                          ],
                        ),
                      ),

                      _QuantitySelector(
                        count: chefChoiceCount,
                        canAdd: totalSelected < widget.quantity,
                        onAdd: _addChefChoice,
                        onRemove: _removeChefChoice,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  'OR CHOOSE THE FLAVOURS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: Colors.grey.shade500,
                  ),
                ),

                const SizedBox(height: 12),

                // =========================================================
                // COOKIE LIST
                // =========================================================
                ...cookies.map((document) {
                  final data = document.data();

                  final name = data['name']?.toString() ?? 'Naim Cookie';

                  final picture = data['picture']?.toString() ?? '';

                  final imageScale =
                      (data['imageScale'] as num?)?.toDouble() ?? 1.0;

                  final count = selectedCookies[document.id] ?? 0;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),

                    child: Container(
                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),

                        border: Border.all(
                          color: count > 0 ? Colors.black : Colors.transparent,
                          width: count > 0 ? 1.5 : 1,
                        ),
                      ),

                      child: Row(
                        children: [
                          // COOKIE IMAGE
                          Container(
                            width: 72,
                            height: 72,

                            decoration: BoxDecoration(
                              color: const Color(0xFFF2EEE9),
                              borderRadius: BorderRadius.circular(18),
                            ),

                            child: picture.isEmpty
                                ? const Icon(
                                    Icons.cookie_outlined,
                                    size: 34,
                                    color: Color(0xFF2D160E),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(7),

                                    child: Transform.scale(
                                      scale: imageScale,

                                      child: Image.network(
                                        picture,
                                        fit: BoxFit.contain,

                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.cookie_outlined,
                                                size: 34,
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                          ),

                          const SizedBox(width: 18),

                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),

                          // QUANTITY SELECTOR
                          _QuantitySelector(
                            count: count,
                            canAdd: totalSelected < widget.quantity,
                            onAdd: () {
                              _addCookie(document.id);
                            },
                            onRemove: () {
                              _removeCookie(document.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 18),

                // =========================================================
                // CONTINUE
                // =========================================================
                SizedBox(
                  width: double.infinity,

                  child: FilledButton(
                    onPressed: selectionComplete
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => GiveSummaryScreen(
                                  selectedCookies: Map<String, int>.from(
                                    selectedCookies,
                                  ),
                                  chefChoiceCount: chefChoiceCount,
                                ),
                              ),
                            );
                          }
                        : null,

                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      disabledBackgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.white,

                      padding: const EdgeInsets.symmetric(vertical: 17),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: Text(
                      selectionComplete
                          ? 'CONTINUE TO GIFT'
                          : 'CHOOSE ${widget.quantity - totalSelected} MORE',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==========================================================================
// QUANTITY SELECTOR
// ==========================================================================

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.count,
    required this.canAdd,
    required this.onAdd,
    required this.onRemove,
  });

  final int count;
  final bool canAdd;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (count > 0) _SmallButton(icon: Icons.remove, onTap: onRemove),

        if (count > 0) ...[
          const SizedBox(width: 8),

          SizedBox(
            width: 24,
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ),

          const SizedBox(width: 8),
        ],

        _SmallButton(icon: Icons.add, onTap: canAdd ? onAdd : null),
      ],
    );
  }
}

// ==========================================================================
// SMALL +/- BUTTON
// ==========================================================================

class _SmallButton extends StatelessWidget {
  const _SmallButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(30),

      child: Container(
        width: 34,
        height: 34,

        decoration: BoxDecoration(
          color: onTap == null ? Colors.grey.shade200 : Colors.black,

          shape: BoxShape.circle,
        ),

        child: Icon(
          icon,
          size: 18,
          color: onTap == null ? Colors.grey : Colors.white,
        ),
      ),
    );
  }
}
