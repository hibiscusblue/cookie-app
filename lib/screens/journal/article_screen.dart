import 'package:flutter/material.dart';

import 'journal_article.dart';

class ArticleScreen extends StatelessWidget {
  final JournalArticle article;

  const ArticleScreen({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: const Text(
          'NAIM JOURNAL',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.category.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              article.title,
              style: const TextStyle(
                fontSize: 38,
                height: 1.04,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2D160E),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              article.subtitle,
              style: TextStyle(
                fontSize: 17,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                if (article.date != null)
                  Text(
                    _formatDate(article.date!),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),

                if (article.date != null)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '•',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),

                Text(
                  _readTime(article.content),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            if (article.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.network(
                    article.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Container(
                        color: const Color(0xFFF2EEE9),
                        child: const Center(
                          child: Icon(
                            Icons.auto_stories_outlined,
                            size: 42,
                            color: Color(0xFF2D160E),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            if (article.image.isNotEmpty)
              const SizedBox(height: 34),

            Container(
              width: 42,
              height: 2,
              color: const Color(0xFF2D160E),
            ),

            const SizedBox(height: 26),

            Text(
              article.content,
              style: const TextStyle(
                fontSize: 17,
                height: 1.75,
                color: Color(0xFF2D160E),
              ),
            ),

            const SizedBox(height: 42),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF2EEE9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FROM NAIM',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                      color: Colors.grey,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Made with intention.',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2D160E),
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    'Every recipe, ingredient and story is part of the world behind Naim.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.grey,
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

String _readTime(String content) {
  if (content.trim().isEmpty) {
    return '1 min read';
  }

  final words = content.trim().split(
        RegExp(r'\s+'),
      );

  final minutes = (words.length / 200).ceil();

  return '$minutes min read';
}

String _formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}