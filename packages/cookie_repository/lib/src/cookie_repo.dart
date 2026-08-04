import 'models/models.dart';

abstract class CookieRepo {
  Future<List<Cookie>> getCookies();
}