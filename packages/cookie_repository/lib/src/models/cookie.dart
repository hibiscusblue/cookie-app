import 'package:cookie_repository/src/entities/entities.dart';
import 'package:cookie_repository/src/models/models.dart';

class Cookie {
  String cookieId;
  String picture;
  bool isFru;
  int sweet;
  String name;
  String description;
  int price;
  int discount;
  Macros macros;

  Cookie({
    required this.cookieId,
    required this.picture,
    required this.isFru,
    required this.sweet,
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.macros,
  }
  );

  CookieEntity toEntity() {
    return CookieEntity(
      cookieId: cookieId,
      picture: picture,
      isFru: isFru,
      sweet: sweet,
      name: name,
      description: description,
      price: price,
      discount: discount,
      macros: macros,
    );
  }

  static Cookie fromEntity(CookieEntity entity) {
    return Cookie(
      cookieId: entity.cookieId,
      picture: entity.picture,
      isFru: entity.isFru,
      sweet: entity.sweet,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      discount: entity.discount,
      macros: entity.macros,
    );
  }
}
