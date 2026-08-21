import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'article_screen.dart';
import 'journal_article.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

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
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('journal_articles')
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              debugPrint('JOURNAL ERROR: ${snapshot.error}');

              return const Center(
                child: Text(
                  'Unable to load the journal.',
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const _EmptyJournal();
            }

            final articles = snapshot.data!.docs
                .map(
                  (doc) => JournalArticle.fromDocument(doc),
                )
                .toList();

            JournalArticle? featured;

            for (final article in articles) {
              if (article.featured) {
                featured = article;
                break;
              }
            }

            featured ??= articles.first;

            final latestArticles = articles
                .where((article) => article.id != featured!.id)
                .toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                24,
                18,
                24,
                50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Stories, ingredients\n& inspiration.',
                    style: TextStyle(
                      fontSize: 34,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2D160E),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'A quiet corner of Naim for recipes, ingredients, '
                    'ideas and the stories behind what we create.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 34),

                  const Text(
                    'FEATURED',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.6,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _FeaturedArticleCard(
                    article: featured,
                  ),

                  if (latestArticles.isNotEmpty) ...[
                    const SizedBox(height: 42),

                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Latest stories',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2D160E),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'From the Naim kitchen and beyond.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ...latestArticles.map(
                      (article) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: 18,
                        ),
                        child: _JournalArticleCard(
                          article: article,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeaturedArticleCard extends StatelessWidget {
  final JournalArticle article;

  const _FeaturedArticleCard({
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: () {
        _openArticle(context, article);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF2EEE9),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.image.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
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
                      return const _ImagePlaceholder();
                    },
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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

                      const SizedBox(width: 10),

                      const Text(
                        '•',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        _readTime(article.content),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 28,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2D160E),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    article.subtitle,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      const Text(
                        'Read story',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF2D160E),
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: Color(0xFF2D160E),
                      ),

                      const Spacer(),

                      if (article.date != null)
                        Text(
                          _formatDate(article.date!),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
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

class _JournalArticleCard extends StatelessWidget {
  final JournalArticle article;

  const _JournalArticleCard({
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        _openArticle(context, article);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.black.withOpacity(0.06),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.image.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    article.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return const _ImagePlaceholder();
                    },
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        article.category.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.3,
                          color: Colors.grey,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        _readTime(article.content),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 21,
                      height: 1.12,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2D160E),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    article.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      if (article.date != null)
                        Text(
                          _formatDate(article.date!),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),

                      const Spacer(),

                      const Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: Color(0xFF2D160E),
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

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEAE3DC),
      child: const Center(
        child: Icon(
          Icons.auto_stories_outlined,
          size: 40,
          color: Color(0xFF2D160E),
        ),
      ),
    );
  }
}

class _EmptyJournal extends StatelessWidget {
  const _EmptyJournal();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(
        child: Text(
          'Something beautiful is baking.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

void _openArticle(
  BuildContext context,
  JournalArticle article,
) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => ArticleScreen(
        article: article,
      ),
    ),
  );
}

String _readTime(String content) {
  final words = content.trim().split(
        RegExp(r'\s+'),
      );

  if (content.trim().isEmpty) {
    return '1 min read';
  }

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