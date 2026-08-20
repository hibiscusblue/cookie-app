import 'package:cookie_repository/src/entities/entities.dart';
import 'package:cookie_repository/src/models/models.dart';

class Cookie {
  String cookieId;
  String picture;
  String label1;
  String label2;
  String name;
  String description;
  double price;
  String ingredients;
  double discount;
  Macros macros;
  String themeColor;
  double imageScale;

  Cookie({
    required this.cookieId,
    required this.picture,
    required this.label1,
    required this.label2,
    required this.name,
    required this.description,
    required this.price,
    required this.ingredients,
    required this.discount,
    required this.macros,
    required this.themeColor,
    required this.imageScale,
  });

  CookieEntity toEntity() {
    return CookieEntity(
      cookieId: cookieId,
      picture: picture,
      label1: label1,
      label2: label2,
      name: name,
      description: description,
      price: price,
      ingredients: ingredients,
      discount: discount,
      macros: macros,
      themeColor: themeColor,
      imageScale: imageScale,
    );
  }

  static Cookie fromEntity(CookieEntity entity) {
    return Cookie(
      cookieId: entity.cookieId,
      picture: entity.picture,
      label1: entity.label1,
      label2: entity.label2,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      ingredients: entity.ingredients,
      discount: entity.discount,
      macros: entity.macros,
      themeColor: entity.themeColor,
      imageScale: entity.imageScale,
    );
  }
}
