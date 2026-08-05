class MacrosEntity {
  int calories;
  int proteins;
  int fat;
  int carbs;

  MacrosEntity({
    required this.calories,
    required this.proteins,
    required this.fat,
    required this.carbs,
  });

  Map<String, Object?> toDocument() {
    return {
      'calories': calories,
      'proteins': proteins,
      'fat': fat,
      'carbs': carbs,
    };
  }

  static MacrosEntity fromDocument(Map<String, dynamic> doc) {
    return MacrosEntity(
      calories: _intValue(doc['calories'], 'macros.calories'),
      proteins: _intValue(doc['proteins'], 'macros.proteins'),
      fat: _intValue(doc['fat'], 'macros.fat'),
      carbs: _intValue(doc['carbs'], 'macros.carbs'),
    );
  }

  static int _intValue(Object? value, String field) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    throw FormatException('Cookie field "$field" must be a number.');
  }
}
