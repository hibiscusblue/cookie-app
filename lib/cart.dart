import 'package:cookie_repository/cookie_repository.dart';

class Cart {
  static final List<Cookie> items = [];

  static void add(Cookie cookie) {
    items.add(cookie);
  }

  static void remove(Cookie cookie) {
    items.remove(cookie);
  }

  static double get total {
    return items.fold(
      0,
      (sum, cookie) => sum + cookie.discount,
    );
  }
}