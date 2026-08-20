import 'package:flutter/material.dart';

Color cookieThemeColor(String hex) {
  final cleaned = hex.replaceAll('#', '');

  return Color(
    int.parse('FF$cleaned', radix: 16),
  );
}