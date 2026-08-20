import 'package:flutter/material.dart';

Color labelColor(String label) {
  switch (label.toUpperCase()) {
    case 'FRUITY':
      return const Color(0xFFD94A64);

    case 'VANILLA':
      return const Color(0xFFE5B93F);

    case 'SPICED':
      return const Color(0xFFC66A2B);

    case 'NUTTY':
      return const Color(0xFF9A6540);

    case 'COCOA':
    case 'CHOCO':
      return const Color(0xFF5D3427);

    case 'CITRUS':
      return const Color(0xFFF28C28);

    default:
      return Colors.grey;
  }
}