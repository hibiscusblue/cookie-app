import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/give/give_cookie_selection_screen.dart';
import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';

class GiveCookieScreen extends StatefulWidget {
  const GiveCookieScreen({super.key});

  @override
  State<GiveCookieScreen> createState() => _GiveCookieScreenState();
}

class _GiveCookieScreenState extends State<GiveCookieScreen> {
  int quantity = 1;

  String? selectedCharity;

  final List<_CharityOption> charities = const [
    _CharityOption(
      name: 'Voedselbank',
      description:
          'Helping people and families who need extra support with food.',
      icon: Icons.shopping_basket_outlined,
      available: true,
    ),
    _CharityOption(
      name: 'Local Shelter',
      description:
          'Sharing a little moment of comfort with people experiencing homelessness.',
      icon: Icons.home_outlined,
      available: false,
    ),
    _CharityOption(
      name: 'Children & Families',
      description:
          'Supporting children and families going through difficult circumstances.',
      icon: Icons.family_restroom_outlined,
      available: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DONATE COOKIES',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),

            const SizedBox(height: 8),

            Text(
              'Choose where you would like your cookies to go.',
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'CHOOSE A CAUSE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.3,
                color: Color(0xFF9B9895),
              ),
            ),

            const SizedBox(height: 14),

            ...charities.map(
              (charity) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _CharityCard(
                  charity: charity,
                  selected: selectedCharity == charity.name,
                  onTap: charity.available
                      ? () {
                          setState(() {
                            selectedCharity = charity.name;
                          });
                        }
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 20),

            AnimatedOpacity(
              opacity: selectedCharity == null ? 0.45 : 1,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: selectedCharity == null,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2EEE9),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.favorite_outline,
                          size: 28,
                          color: Color(0xFF2D160E),
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'How many cookies?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 6),

                      if (selectedCharity != null)
                        Text(
                          'for $selectedCharity',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _QuantityButton(
                            icon: Icons.remove,
                            onTap: quantity > 1
                                ? () {
                                    setState(() {
                                      quantity--;
                                    });
                                  }
                                : null,
                          ),

                          SizedBox(
                            width: 90,
                            child: Center(
                              child: Text(
                                '$quantity',
                                style: const TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),

                          _QuantityButton(
                            icon: Icons.add,
                            onTap: quantity < 12
                                ? () {
                                    setState(() {
                                      quantity++;
                                    });
                                  }
                                : null,
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Text(
                        quantity == 1
                            ? '1 cookie to share'
                            : '$quantity cookies to share',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Maximum 12 cookies per gift',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF2EEE9),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.volunteer_activism_outlined,
                    size: 22,
                    color: Color(0xFF2D160E),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Text(
                      'You choose the cookies. Naim takes care of getting '
                      'them to the selected organisation.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: selectedCharity == null
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => GiveCookieSelectionScreen(
                              quantity: quantity,
                              charityName: selectedCharity!,
                            ),
                          ),
                        );
                      },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade500,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'CHOOSE COOKIES',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CharityCard extends StatelessWidget {
  const _CharityCard({
    required this.charity,
    required this.selected,
    required this.onTap,
  });

  final _CharityOption charity;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final unavailable = !charity.available;

    return Opacity(
      opacity: unavailable ? 0.6 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: selected ? Colors.black : Colors.black.withValues(alpha: 0.05),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2EEE9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    charity.icon,
                    color: const Color(0xFF2D160E),
                    size: 23,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              charity.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),

                          if (selected)
                            const Icon(
                              Icons.check_circle,
                              size: 21,
                              color: Colors.black,
                            ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      Text(
                        charity.description,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      if (unavailable) ...[
                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2EEE9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'COMING SOON',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ],
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

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey.shade300,
        disabledForegroundColor: Colors.white,
      ),
      icon: Icon(icon),
    );
  }
}

class _CharityOption {
  const _CharityOption({
    required this.name,
    required this.description,
    required this.icon,
    required this.available,
  });

  final String name;
  final String description;
  final IconData icon;
  final bool available;
}
