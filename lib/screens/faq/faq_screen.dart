import 'package:flutter/material.dart';

import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/components/naim_footer.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FAQ',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Everything you might want to know.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const _FaqItem(
                    question: 'What is Today\'s Drop?',
                    answer:
                        'Today\'s Drop is a small, limited batch of one '
                        'selected Naim cookie. Once the last cookie is '
                        'claimed, the drop is sold out.',
                  ),

                  const _FaqItem(
                    question: 'What happens when a drop sells out?',
                    answer:
                        'When it\'s gone, it\'s gone. A sold-out drop '
                        'cannot be ordered again that day. Keep an eye '
                        'on Naim for the next release.',
                  ),

                  const _FaqItem(
                    question: 'Can I order more than one cookie?',
                    answer:
                        'Yes. You can choose your quantity while stock '
                        'is available. Limited drops may have fewer '
                        'cookies remaining.',
                  ),

                  const _FaqItem(
                    question: 'How do I receive my order?',
                    answer:
                        'Naim currently offers pickup in Venlo. '
                        'Additional delivery options may be introduced '
                        'in the future.',
                  ),

                  const _FaqItem(
                    question: 'How do I pay?',
                    answer:
                        'Orders currently use Tikkie as the planned '
                        'payment method. More payment options may be '
                        'added as Naim grows.',
                  ),

                  // const _FaqItem(
                  //   question: 'Can I send cookies to someone else?',
                  //   answer:
                  //       'Yes. Through Give, you can choose cookies for '
                  //       'someone else and include a personal message.',
                  // ),

                  // const _FaqItem(
                  //   question: 'What is Give?',
                  //   answer:
                  //       'Give is Naim\'s gifting and charity feature. '
                  //       'It allows you to share cookies with another '
                  //       'person and turn a small treat into a small act '
                  //       'of kindness.',
                  // ),

                  const _FaqItem(
                    question: 'Can I save my favourite cookies?',
                    answer:
                        'Yes. Tap the heart on a cookie and it will be '
                        'saved to your Favorites so you can easily find '
                        'it again.',
                  ),

                  const _FaqItem(
                    question: 'Where can I see my orders?',
                    answer:
                        'Your previous orders are available under '
                        'My Orders in the Naim menu.',
                  ),

                  const _FaqItem(
                    question: 'I still have a question. What should I do?',
                    answer:
                        'You can visit the Contact page from the Naim '
                        'menu and get in touch with us.',
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

class _FaqItem extends StatelessWidget {
  const _FaqItem({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 4,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            18,
            0,
            18,
            18,
          ),
          iconColor: const Color(0xFF2D160E),
          collapsedIconColor: const Color(0xFF2D160E),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D160E),
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}