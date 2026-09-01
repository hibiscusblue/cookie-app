import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/naim_footer.dart';

class OurStoryScreen extends StatelessWidget {
  const OurStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F7),
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'OUR STORY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.2,
                  color: Color(0xFF9B9895),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'More than\na cookie.',
                style: TextStyle(
                  fontSize: 42,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.3,
                ),
              ),

              const SizedBox(height: 22),

              Text(
                'Naim began with a simple idea: that something small '
                'can create a beautiful moment.',
                style: TextStyle(
                  fontSize: 18,
                  height: 1.55,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),

              const SizedBox(height: 42),

              _StoryImage(),

              const SizedBox(height: 44),

              const _StorySection(
                eyebrow: 'THE BEGINNING',
                title: 'Made from curiosity.',
                text:
                    'Naim grew from experimenting in the kitchen — '
                    'discovering new flavours, rethinking familiar recipes '
                    'and asking whether a cookie could be delicious, '
                    'beautiful and made with more thoughtful ingredients '
                    'at the same time.',
              ),

              const _StorySection(
                eyebrow: 'OUR PHILOSOPHY',
                title: 'Small batch. Big intention.',
                text:
                    'We believe food does not need to be complicated to feel '
                    'special. Naim cookies are made in small batches, with '
                    'carefully chosen ingredients and flavours designed to '
                    'turn an ordinary part of the day into something worth '
                    'remembering.',
              ),

              const _QuoteCard(),

              const SizedBox(height: 44),

              const _StorySection(
                eyebrow: 'THE COLLECTION',
                title: 'A little world of flavours.',
                text:
                    'Blueberry vanilla. Raspberry cacao. Apple cinnamon. '
                    'Marzipan. Nutella. Each flavour has its own personality, '
                    'its own colours and its own story. The collection is '
                    'always allowed to grow, change and surprise you.',
              ),

              // const _StorySection(
              //   eyebrow: 'GIVE',
              //   title: 'Bliss is better when shared.',
              //   text:
              //       'Naim is not only about receiving something beautiful. '
              //       'It is also about giving. Through Naim Give, a cookie can '
              //       'become a small act of kindness — sent to someone simply '
              //       'to make their day a little brighter.',
              // ),

              // const SizedBox(height: 10),

              Center(
                child: Image.asset(
                  'assets/blueberry-vanilla.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),

              const Center(
                child: Text(
                  'NAIM',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  'Your Moment of Bliss',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.4,
                  ),
                ),
              ),

              const SizedBox(height: 42),

              Center(
                child: Container(
                  width: 38,
                  height: 1,
                  color: Colors.grey.shade400,
                ),
              ),
              const NaimFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// STORY IMAGE
// ============================================================================

class _StoryImage extends StatelessWidget {
  const _StoryImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        color: const Color(0xFFF0EDE9),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: -20,
            bottom: -12,
            child: Opacity(
              opacity: 0.18,
              child: Image.asset(
                'assets/blueberry-vanilla.png',
                width: 190,
                height: 190,
              ),
            ),
          ),
          Image.asset(
            'assets/blueberry-vanilla.png',
            width: 185,
            height: 185,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// STORY SECTION
// ============================================================================

class _StorySection extends StatelessWidget {
  const _StorySection({
    required this.eyebrow,
    required this.title,
    required this.text,
  });

  final String eyebrow;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 46),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.8,
              color: Color(0xFFA09D99),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 27,
              height: 1.15,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              height: 1.7,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// QUOTE CARD
// ============================================================================

class _QuoteCard extends StatelessWidget {
  const _QuoteCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 48),
      padding: const EdgeInsets.symmetric(
        horizontal: 26,
        vertical: 36,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2D160E),
        borderRadius: BorderRadius.circular(26),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '“',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 54,
              height: 0.8,
            ),
          ),

          SizedBox(height: 12),

          Text(
            'A small moment of sweetness can become a moment of bliss.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 20),

          Text(
            'THE IDEA BEHIND NAIM',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.7,
            ),
            
          ),
          
        ],
        
      ),
      
    );
    
  }
  
}