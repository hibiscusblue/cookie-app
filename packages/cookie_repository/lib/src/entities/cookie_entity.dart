import 'package:cookie_repository/src/entities/macros_entity.dart';
import 'package:cookie_repository/src/models/macros.dart';

class CookieEntity {
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

  CookieEntity({
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
  });

  Map<String, Object?> toDocument() {
    return {
      'cookieId': cookieId,
      'picture': picture,
      'label1': label1,
      'label2': label2,
      'name': name,
      'description': description,
      'price': price,
      'ingredients': ingredients,
      'discount': discount,
      'macros': macros.toEntity().toDocument(),
    };
  }

  static CookieEntity fromDocument(
    Map<String, dynamic> doc, {
    String? documentId,
  }) {
    return CookieEntity(
      cookieId: _stringValue(
        doc['cookieId'] ?? documentId,
        'cookieId',
        fallback: documentId ?? 'unknown-cookie',
      ),
      picture: _stringValue(doc['picture'], 'picture', fallback: ''),
      label1: _stringValue(doc['label1'], 'label1', fallback: ''),
      label2: _stringValue(doc['label2'], 'label2', fallback: ''),
      name: _stringValue(doc['name'], 'name', fallback: 'Unnamed cookie'),
      description: _stringValue(
        doc['description'],
        'description',
        fallback: '',
      ),
      ingredients: _stringValue(
        doc['ingredients'],
        'ingredients',
        fallback: '',
      ),
      price: _doubleValue(doc['price'], 'price', fallback: 0),
      discount: _doubleValue(doc['discount'], 'discount', fallback: 0),
      macros: Macros.fromEntity(
        MacrosEntity.fromDocument(
          _mapValue(doc['macros'], 'macros', fallback: const {}),
        ),
      ),
    );
  }

  static String _stringValue(
    Object? value,
    String field, {
    required String fallback,
  }) {
    if (value == null) return fallback;
    if (value is String) return value;
    throw FormatException('Cookie field "$field" must be text.');
  }

  static bool _boolValue(
    Object? value,
    String field, {
    required bool fallback,
  }) {
    if (value == null) return fallback;
    if (value is bool) return value;
    throw FormatException('Cookie field "$field" must be true or false.');
  }

  static int _intValue(
    Object? value,
    String field, {
    required int fallback,
  }) {
    if (value == null) return fallback;
    if (value is num) return value.toInt();
    throw FormatException('Cookie field "$field" must be a number.');
  }

  static double _doubleValue(
    Object? value,
    String field, {
    required double fallback,
  }) {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    throw FormatException('Cookie field "$field" must be a number.');
  }

  static Map<String, dynamic> _mapValue(
    Object? value,
    String field, {
    required Map<String, dynamic> fallback,
  }) {
    if (value == null) return fallback;
    if (value is Map) return Map<String, dynamic>.from(value);
    throw FormatException('Cookie field "$field" must be an object.');
  }
}
