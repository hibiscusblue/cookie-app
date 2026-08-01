class CookieEntity{
    String cookieId;
  String picture;
  bool isFru;
  int sweet;
  String name;
  String description;
  double price;
  double discount;
  List<Macros> macros;

  CookieEntity({
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

    Map<String, Object?> toDocument() {
    return {
      'cookieId': cookieId,
      'picture': picture,
      'isFru': isFru,
      'sweet': sweet,
      'name': name,
      'description': description,
      'price': price,
      'discount': discount,
      'macros': macros,
    };
  }

  static CookieEntity fromDocument(Map<String, dynamic> doc) {
    return CookieEntity(
 cookieId: doc['cookieId'],
 picture: doc['picture'],
 isFru: doc['isFru'],
 sweet: doc['sweet'],
 name: doc['name'],
 description: doc['description'],
 price: doc['price'],
 discount: doc['discount'],
 macros: doc['macros'],
    );
  }
}