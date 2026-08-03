import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_repository/src/cookie_repository.dart';

class FirebaseCookieRepo implements CookieRepo {
final cookieCollection =
            (firestore ?? FirebaseFirestore.instance).collection('cookies');
            
              static FirebaseFirestore? get firestore => null;

              Future<List<Cookie>> getCookies() async {
                try {
                    return await cookieCollection
                    .get()
                    .then((value) => value.docs.map((e) => Cookie.fromEntity(CookieEntity.fromDocument(e.data()))).toList());
                } catch (e) {
                  log(e.toString());
                  rethrow;
                }
              }
}