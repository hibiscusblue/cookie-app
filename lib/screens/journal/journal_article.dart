import 'package:cloud_firestore/cloud_firestore.dart';

class JournalArticle {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String image;
  final String content;
  final bool featured;
  final DateTime? date;

  JournalArticle({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.image,
    required this.content,
    required this.featured,
    required this.date,
  });

  factory JournalArticle.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return JournalArticle(
      id: doc.id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      category: data['category'] ?? '',
      image: data['image'] ?? '',
      content: data['content'] ?? '',
      featured: data['featured'] ?? false,
      date: (data['date'] as Timestamp?)?.toDate(),
    );
  }
}