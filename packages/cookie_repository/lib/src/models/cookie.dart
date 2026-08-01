class Cookie {
  String cookieId;
  String picture;
  bool isFru;
  int sweet;
  String name;
  String description;
  double price;
  double discount;
  List<Macros> macros;

  Cookie(
    this.cookieId,
    this.picture,
    this.isFru,
    this.sweet,
    this.name,
    this.description,
    this.price,
    this.discount,
    this.macros,
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
