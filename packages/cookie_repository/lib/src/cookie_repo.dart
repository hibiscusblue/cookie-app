import 'models/models.dart';

abstract class CookieRepo {
  Future<List<Cookie>> getCookies();

  Future<void> createCookie(Cookie cookie);
}