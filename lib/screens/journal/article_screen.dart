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
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.category.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              article.title,
              style: const TextStyle(
                fontSize: 36,
                height: 1.05,
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

            const SizedBox(height: 30),

            if (article.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  article.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            if (article.image.isNotEmpty)
              const SizedBox(height: 30),

            Text(
              article.content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.7,
                color: Color(0xFF2D160E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
