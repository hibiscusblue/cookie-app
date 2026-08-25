import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter/foundation.dart';

class Favorites {
  static final List<Cookie> _items = [];

  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  static List<Cookie> get items => List.unmodifiable(_items);

  static bool contains(Cookie cookie) {
    return _items.any(
      (item) => item.cookieId == cookie.cookieId,
    );
  }

  static void add(Cookie cookie) {
    if (contains(cookie)) return;

    _items.add(cookie);
    changes.value++;
  }

  static void remove(Cookie cookie) {
    _items.removeWhere(
      (item) => item.cookieId == cookie.cookieId,
    );

    changes.value++;
  }

  static void toggle(Cookie cookie) {
    if (contains(cookie)) {
      remove(cookie);
    } else {
      add(cookie);
    }
  }
}