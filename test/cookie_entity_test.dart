import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses Firestore integer prices and uses the document ID', () {
    final entity = CookieEntity.fromDocument({
      'picture': 'cookie.png',
      'isFru': true,
      'sweet': 2,
      'name': 'Blueberry Vanilla',
      'description': 'Your moment of bliss.',
      'price': 3,
      'discount': 1,
      'macros': {'calories': 250, 'proteins': 4, 'fat': 12, 'carbs': 31},
    }, documentId: 'firestore-id');

    expect(entity.cookieId, 'firestore-id');
    expect(entity.price, 3.0);
    expect(entity.discount, 1.0);
  });

  test('reports the invalid Firestore field', () {
    expect(
      () => CookieEntity.fromDocument({
        'cookieId': 'id',
        'picture': 'cookie.png',
        'isFru': true,
        'sweet': 2,
        'name': 'Cookie',
        'description': 'Description',
        'price': 'three',
        'discount': 1,
        'macros': {'calories': 250, 'proteins': 4, 'fat': 12, 'carbs': 31},
      }),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains('price'),
        ),
      ),
    );
  });

  test('uses safe defaults for missing optional Firestore fields', () {
    final entity = CookieEntity.fromDocument({}, documentId: 'document-id');

    expect(entity.cookieId, 'document-id');
    expect(entity.name, 'Unnamed cookie');
    expect(entity.picture, isEmpty);
    expect(entity.description, isEmpty);
    expect(entity.price, 0);
    expect(entity.macros.calories, 0);
  });
}
