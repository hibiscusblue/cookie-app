import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';

class SeedDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCookies() async {
    final cookies = [
      {
        'name': 'Apple Cinnamon',
        'description': 'Warm Cozy Satisfying',
        'picture':
            'https://raw.githubusercontent.com/hibiscusblue/cookie-app/main/assets/apple-cinnamon.png',
      },
      {
        'name': 'Blueberry Vanilla',
        'description': 'Fresh Sweet Delightful',
        'picture':
            'https://raw.githubusercontent.com/hibiscusblue/cookie-app/main/assets/blueberry-vanilla.png',
      },
      {
        'name': 'Carrot Cake',
        'description': 'Spiced Nutty Comforting',
        'picture':
            'https://raw.githubusercontent.com/hibiscusblue/cookie-app/main/assets/carrot-cake.png',
      },
      {
        'name': 'Cranberry Cashew',
        'description': 'Fruity Creamy Delicious',
        'picture':
            'https://raw.githubusercontent.com/hibiscusblue/cookie-app/main/assets/cranberry-cashew.png',
      },
      {
        'name': 'Orange Chocolate',
        'description': 'Rich Citrusy Indulgent',
        'picture':
            'https://raw.githubusercontent.com/hibiscusblue/cookie-app/main/assets/orange-chocolate.png',
      },
      {
        'name': 'Raspberry Cocoa',
        'description': 'Fruity Chocolatey Blissful',
        'picture':
            'https://raw.githubusercontent.com/hibiscusblue/cookie-app/main/assets/raspberry-cocoa.png',
      },
      {
        'name': 'Raspberry Vanilla',
        'description': 'Soft Fruity Dreamy',
        'picture':
            'https://raw.githubusercontent.com/hibiscusblue/cookie-app/main/assets/raspberry-vanilla.png',
      },
    ];

    final batch = _firestore.batch();
    final cookiesCollection = _firestore.collection('cookies');

    for (final cookie in cookies) {
      // Firestore creates a new random document ID.
      final document = cookiesCollection.doc();

      batch.set(document, {
        'cookieId': document.id,
        'name': cookie['name'],
        'description': cookie['description'],
        'picture': cookie['picture'],
        'price': 3.99,
        'discount': 2.99,
        'isFru': true,
        'sweet': 1,
        'macros': {
          'calories': 244,
          'carbs': 14,
          'fat': 18,
          'proteins': 7,
        },
      });
    }

    await batch.commit();

    developer.log(
      'All cookies were added successfully!',
      name: 'SeedDatabase',
    );
  }
}
