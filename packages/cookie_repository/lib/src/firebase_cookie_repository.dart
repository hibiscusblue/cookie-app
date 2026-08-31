import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_repository/src/cookie_repository.dart';

class FirebaseCookieRepo implements CookieRepo {
  FirebaseCookieRepo({FirebaseFirestore? firestore})
      : cookieCollection =
            (firestore ?? FirebaseFirestore.instance).collection('cookies');

  final CollectionReference<Map<String, dynamic>> cookieCollection;

  @override
  Future<List<Cookie>> getCookies() async {
    try {
      final snapshot = await cookieCollection
          .where('isActive', isEqualTo: true)
          .orderBy('displayOrder')
          .get();

      return snapshot.docs.map((document) {
        try {
          return Cookie.fromEntity(
            CookieEntity.fromDocument(
              document.data(),
              documentId: document.id,
            ),
          );
        } on FormatException catch (error) {
          throw FormatException(
            'Cookie document "${document.id}": ${error.message}',
          );
        }
      }).toList();
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  @override
  Future<void> createCookie(Cookie cookie) async {
    try {
      final document = cookieCollection.doc();

      cookie.cookieId = document.id;

      await document.set(
        cookie.toEntity().toDocument(),
      );
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }
}
