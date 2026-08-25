import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_repository/cookie_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Favorites {
  static final Set<String> _favoriteIds = {};

  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  static String? _loadedUserId;
  static bool _isLoading = false;

  static void _notify() {
    changes.value++;
  }

  static bool contains(Cookie cookie) {
    return _favoriteIds.contains(cookie.cookieId);
  }

  static Set<String> get ids {
    return Set.unmodifiable(_favoriteIds);
  }

  static Future<void> load() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _favoriteIds.clear();
      _loadedUserId = null;
      _notify();
      return;
    }

    // Already loaded for this user
    if (_loadedUserId == user.uid) {
      return;
    }

    if (_isLoading) {
      return;
    }

    _isLoading = true;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .get();

      _favoriteIds
        ..clear()
        ..addAll(
          snapshot.docs.map(
            (doc) => doc.id,
          ),
        );

      _loadedUserId = user.uid;

      _notify();
    } finally {
      _isLoading = false;
    }
  }

  static Future<void> toggle(Cookie cookie) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final favoriteRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(cookie.cookieId);

    final wasFavorite = contains(cookie);

    // Update the screen immediately
    if (wasFavorite) {
      _favoriteIds.remove(cookie.cookieId);
    } else {
      _favoriteIds.add(cookie.cookieId);
    }

    _notify();

    try {
      if (wasFavorite) {
        await favoriteRef.delete();
      } else {
        await favoriteRef.set({
          'cookieId': cookie.cookieId,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      // If Firebase fails, restore the previous state
      if (wasFavorite) {
        _favoriteIds.add(cookie.cookieId);
      } else {
        _favoriteIds.remove(cookie.cookieId);
      }

      _notify();

      debugPrint('FAVORITES ERROR: $e');
    }
  }

  static void reset() {
    _favoriteIds.clear();
    _loadedUserId = null;
    _isLoading = false;
    _notify();
  }
}