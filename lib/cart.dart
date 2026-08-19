import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter/foundation.dart';

class Cart {
  static final List<Cookie> items = [];

  // Tells the app whenever something in the cart changes
  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  static void _notify() {
    changes.value++;
  }

  static void add(Cookie cookie) {
    items.add(cookie);
    _notify();
  }

  static void remove(Cookie cookie) {
    items.remove(cookie);
    _notify();
  }

  static int quantity(Cookie cookie) {
  return items
      .where((item) => item.cookieId == cookie.cookieId)
      .length;
}

static List<Cookie> get uniqueItems {
  final unique = <String, Cookie>{};

  for (final cookie in items) {
    unique[cookie.cookieId] = cookie;
  }

  return unique.values.toList();
}

  static int get totalItems {
    return items.length;
  }

  static int quantityFor(Cookie cookie) {
    return items
        .where((item) => item.cookieId == cookie.cookieId)
        .length;
  }

  static void removeOne(Cookie cookie) {
    final index = items.indexWhere(
      (item) => item.cookieId == cookie.cookieId,
    );

    if (index != -1) {
      items.removeAt(index);
      _notify();
    }
  }

  static double get total {
    return items.fold(
      0,
      (sum, cookie) => sum + cookie.discount,
    );
  }
}