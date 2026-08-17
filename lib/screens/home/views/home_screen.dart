import 'dart:async';
import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/cookie_image.dart';
import 'package:flutter_application_1/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_application_1/screens/home/blocs/get_cookie_bloc/get_cookie_bloc.dart';
import 'package:flutter_application_1/screens/home/views/details_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/cart.dart';
import 'package:flutter_application_1/screens/cart/cart_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const _NaimDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            Image.asset('assets/blueberry-vanilla.png', width: 58, height: 58),
            const SizedBox(width: 8),
            const Text(
              'COOKIES',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
            ),
          ],
        ),
        actions: [
         ValueListenableBuilder<int>(
  valueListenable: Cart.changes,
  builder: (context, _, __) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const CartScreen(),
              ),
            );
          },
          icon: const Icon(
            CupertinoIcons.cart,
          ),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
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

          // IconButton(
          //   onPressed: () {
          //     context.read<SignInBloc>().add(SignOutRequired());
          //   },
          //   icon: const Icon(CupertinoIcons.arrow_right_to_line),
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<GetCookieBloc, GetCookieState>(
          builder: (context, state) {
            return switch (state) {
              GetCookieSuccess() when state.cookies.isEmpty => const Center(
                child: Text('No cookies have been added yet.'),
              ),

              GetCookieSuccess() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DAILY DROP HERO
                  _DailyDropHero(cookies: state.cookies),

                  const SizedBox(height: 24),

                  // COLLECTION TITLE
                  const Text(
                    'THE COLLECTION',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Our most-loved cookies',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 14),

                  // EXISTING COOKIE GRID
                  Expanded(
                    child: GridView.builder(
                      itemCount: state.cookies.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.68,
                          ),
                      itemBuilder: (context, index) {
                        return _CookieCard(cookie: state.cookies[index]);
                      },
                    ),
                  ),
                ],
              ),

              GetCookieFailure() => _FailureView(message: state.message),

              _ => const Center(child: CircularProgressIndicator()),
            };
          },
        ),
      ),
    );
  }
}

Color labelColor(String label) {
  switch (label.toUpperCase()) {
    case 'FRUITY':
      return const Color(0xFFD94A64);

    case 'VANILLA':
      return const Color(0xFFE5B93F);

    case 'SPICED':
      return const Color(0xFFC66A2B);

    case 'NUTTY':
      return const Color(0xFF9A6540);

    case 'COCOA':
    case 'CHOCO':
      return const Color(0xFF5D3427);

    case 'CITRUS':
      return const Color(0xFFF28C28);

    default:
      return Colors.grey;
  }
}

class _DailyDropHero extends StatelessWidget {
  const _DailyDropHero({required this.cookies});

  final List<Cookie> cookies;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('dailyDrops')
          .where('active', isEqualTo: true)
          .limit(1)
          .snapshots(),

      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _DropMessage(message: 'Unable to load today\'s drop.');
        }

        if (!snapshot.hasData) {
          return const SizedBox(
            height: 280,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return const _DropMessage(message: 'No Daily Drop today 🍪');
        }

        final dropDocument = snapshot.data!.docs.first;

        final dropData = dropDocument.data() as Map<String, dynamic>;

        final String cookieId = dropData['cookieId'] as String;

        final int stock = (dropData['stock'] as num).toInt();

        final int sold = (dropData['sold'] as num).toInt();

        final int remaining = (stock - sold).clamp(0, stock);

        final Timestamp endTimestamp = dropData['endTime'] as Timestamp;

        final DateTime endTime = endTimestamp.toDate();

        Cookie? dropCookie;

        for (final cookie in cookies) {
          if (cookie.cookieId == cookieId) {
            dropCookie = cookie;
            break;
          }
        }

        if (dropCookie == null) {
          return const _DropMessage(message: 'Daily Drop cookie not found.');
        }

        final cookie = dropCookie;

        final double stockProgress = stock == 0 ? 0 : remaining / stock;

        final bool soldOut = remaining == 0;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP LABEL
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'TODAY\'S DROP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Text(
                    '$remaining LEFT',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // IMAGE + DETAILS
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: CookieImage(
                      picture: cookie.picture,
                      name: cookie.name,
                    ),
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _Badge(
                              label: cookie.label1,
                              color: labelColor(cookie.label1),
                            ),

                            _Badge(
                              label: cookie.label2,
                              color: labelColor(cookie.label2),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Text(
                          cookie.name,
                          style: const TextStyle(
                            fontSize: 24,
                            height: 1.05,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2D160E),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Text(
                              '€${cookie.discount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF2D160E),
                              ),
                            ),

                            const SizedBox(width: 7),

                            if (cookie.discount > 0)
                              Text(
                                '€${cookie.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade500,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // STOCK BAR
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  value: stockProgress,
                  minHeight: 7,
                  backgroundColor: Colors.grey.shade200,
                  color: soldOut ? Colors.grey : Colors.black,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                soldOut
                    ? 'SOLD OUT'
                    : remaining <= 4
                    ? 'Almost gone — only $remaining left'
                    : '$remaining cookies available today',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: soldOut
                      ? Colors.grey
                      : remaining <= 4
                      ? Colors.red.shade700
                      : Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 16),

_DropCountdown(
  endTime: endTime,
),

const SizedBox(height: 16),

              // ADD BUTTON
            _DropPurchaseControls(
  cookie: cookie,
  remaining: remaining,
),
            ],
          ),
        );
      },
    );
  }
}


class _DropCountdown extends StatefulWidget {
  const _DropCountdown({
    required this.endTime,
  });

  final DateTime endTime;

  @override
  State<_DropCountdown> createState() =>
      _DropCountdownState();
}

class _DropCountdownState
    extends State<_DropCountdown> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();

    _updateRemaining();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        _updateRemaining();
      },
    );
  }

  @override
  void didUpdateWidget(
    covariant _DropCountdown oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.endTime != widget.endTime) {
      _updateRemaining();
    }
  }

  void _updateRemaining() {
    final difference =
        widget.endTime.difference(DateTime.now());

    if (!mounted) return;

    setState(() {
      _remaining = difference.isNegative
          ? Duration.zero
          : difference;
    });
  }

  String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours =
        _remaining.inHours;

    final minutes =
        _remaining.inMinutes.remainder(60);

    final seconds =
        _remaining.inSeconds.remainder(60);

    final expired =
        _remaining == Duration.zero;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4F1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            expired
                ? 'DROP CLOSED'
                : 'DROP CLOSES IN',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            expired
                ? '00 : 00 : 00'
                : '${_twoDigits(hours)} : '
                    '${_twoDigits(minutes)} : '
                    '${_twoDigits(seconds)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: Color(0xFF2D160E),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropPurchaseControls extends StatefulWidget {
  const _DropPurchaseControls({
    required this.cookie,
    required this.remaining,
  });

  final Cookie cookie;
  final int remaining;

  @override
  State<_DropPurchaseControls> createState() =>
      _DropPurchaseControlsState();
}

class _DropPurchaseControlsState
    extends State<_DropPurchaseControls> {
  int quantity = 1;

  void _increase() {
    if (quantity < widget.remaining) {
      setState(() {
        quantity++;
      });
    }
  }

  void _decrease() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _addToCart() {
    for (int i = 0; i < quantity; i++) {
      Cart.add(widget.cookie);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$quantity × ${widget.cookie.name} added to cart 🍪',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final soldOut = widget.remaining == 0;

    final total =
        widget.cookie.discount * quantity;

    if (soldOut) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: FilledButton(
          onPressed: null,
          child: const Text(
            'SOLD OUT',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            const Text(
              'QUANTITY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),

            const Spacer(),

            _DropQuantityButton(
              icon: CupertinoIcons.minus,
              enabled: quantity > 1,
              onPressed: _decrease,
            ),

            SizedBox(
              width: 48,
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D160E),
                ),
              ),
            ),

            _DropQuantityButton(
              icon: CupertinoIcons.plus,
              enabled: quantity < widget.remaining,
              onPressed: _increase,
            ),
          ],
        ),

        const SizedBox(height: 14),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: FilledButton(
            onPressed: _addToCart,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'ADD $quantity TO CART  •  €${total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropQuantityButton extends StatelessWidget {
  const _DropQuantityButton({
    required this.icon,
    required this.onPressed,
    required this.enabled,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFFF2EEE9)
              : Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 17,
          color: enabled
              ? const Color(0xFF2D160E)
              : Colors.grey.shade400,
        ),
      ),
    );
  }
}

class _DropMessage extends StatelessWidget {
  const _DropMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _CookieCard extends StatelessWidget {
  const _CookieCard({required this.cookie});

  final Cookie cookie;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => DetailsScreen(cookie: cookie),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox.expand(
                  child: CookieImage(
                    picture: cookie.picture,
                    name: cookie.name,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FRUITY + BALANCE
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _Badge(
                        label: cookie.label1,
                        color: labelColor(cookie.label1),
                      ),
                      _Badge(
                        label: cookie.label2,
                        color: labelColor(cookie.label2),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // COOKIE NAME
                  Text(
                    cookie.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // DESCRIPTION
                  // Text(
                  //   cookie.description,
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  // ),
                  const SizedBox(height: 6),

                  // PRICE + ADD BUTTON
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 5,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              '€${cookie.discount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2D160E),
                              ),
                            ),

                            if (cookie.discount > 0)
                              Text(
                                '€${cookie.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade500,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ),

               ValueListenableBuilder<int>(
  valueListenable: Cart.changes,
  builder: (context, _, __) {
    final quantity = Cart.quantityFor(cookie);

    if (quantity == 0) {
      return IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: () {
          Cart.add(cookie);
        },
        icon: const Icon(
          CupertinoIcons.add_circled_solid,
          size: 28,
          color: Colors.black,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CollectionQuantityButton(
          icon: CupertinoIcons.minus,
          onPressed: () {
            Cart.removeOne(cookie);
          },
        ),

        SizedBox(
          width: 26,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ),

        _CollectionQuantityButton(
          icon: CupertinoIcons.plus,
          onPressed: () {
            Cart.add(cookie);
          },
        ),
      ],
    );
  },
),
                    ],
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

class _CollectionQuantityButton extends StatelessWidget {
  const _CollectionQuantityButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 27,
        height: 27,
        decoration: BoxDecoration(
          color: const Color(0xFFF2EEE9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 14,
          color: const Color(0xFF2D160E),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color, this.background});

  final String label;
  final Color color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background ?? color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                context.read<GetCookieBloc>().add(GetCookie());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
      class _NaimDrawer extends StatelessWidget {
  const _NaimDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF8F8F8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  22,
                  20,
                  20,
                ),
                children: [
                  // BRAND
                  Row(
                    children: [
                      Image.asset(
                        'assets/blueberry-vanilla.png',
                        width: 52,
                        height: 52,
                      ),

                      const SizedBox(width: 12),

                      const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
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

                  _DrawerSectionTitle(
                    title: 'TODAY',
                  ),

                  _DrawerItem(
                    icon: CupertinoIcons.sparkles,
                    title: 'Today\'s Drop',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 18),

                  _DrawerSectionTitle(
                    title: 'DISCOVER',
                  ),

                  _DrawerItem(
                    icon: CupertinoIcons.square_grid_2x2,
                    title: 'The Collection',
                    onTap: () {
                      _openNaimPage(
                        context,
                        title: 'THE COLLECTION',
                        subtitle:
                            'Our most-loved cookies',
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
                        subtitle:
                            'Cookies you love most',
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
                        subtitle:
                            'A little taste of Naim',
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
                        subtitle:
                            'Stories, ingredients & inspiration',
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  _DrawerSectionTitle(
                    title: 'YOUR NAIM',
                  ),

                  _DrawerItem(
                    icon: CupertinoIcons.bag,
                    title: 'My Orders',
                    onTap: () {
                      _openNaimPage(
                        context,
                        title: 'MY ORDERS',
                        subtitle:
                            'Your cookie history',
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
                        subtitle:
                            'Your Naim profile',
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  _DrawerSectionTitle(
                    title: 'ABOUT',
                  ),

                  _DrawerItem(
                    icon: CupertinoIcons.heart_fill,
                    title: 'Our Story',
                    onTap: () {
                      _openNaimPage(
                        context,
                        title: 'OUR STORY',
                        subtitle:
                            'Why Naim exists',
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

            // LOG OUT
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(20, 8, 20, 18),
              child: Column(
                children: [
                  const Divider(),

                  const SizedBox(height: 6),

                  _DrawerItem(
                    icon:
                        CupertinoIcons.arrow_right_to_line,
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
      minLeadingWidth: 24,
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
  
