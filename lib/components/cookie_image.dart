import 'package:flutter/material.dart';

class CookieImage extends StatelessWidget {
  const CookieImage({
    required this.picture,
    required this.name,
    this.fit = BoxFit.contain,
    super.key,
  });

  final String picture;
  final String name;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final source = picture.trim();
    final fallback =
        'assets/${name.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}.png';

    if (source.startsWith('http://') || source.startsWith('https://')) {
      return Image.network(
        source,
        fit: fit,
        errorBuilder: (_, _, _) => _assetImage(fallback),
      );
    }

    final asset = source.isEmpty
        ? fallback
        : source.startsWith('assets/')
        ? source
        : 'assets/$source';
    return _assetImage(asset, fallback: fallback);
  }

  Widget _assetImage(String asset, {String? fallback}) {
    return Image.asset(
      asset,
      fit: fit,
      errorBuilder: (_, _, _) {
        if (fallback != null && fallback != asset) {
          return Image.asset(fallback, fit: fit, errorBuilder: _placeholder);
        }
        return _placeholder(null, null, null);
      },
    );
  }

  Widget _placeholder(BuildContext? _, Object? _, StackTrace? _) {
    return const Center(
      child: Icon(Icons.cookie_outlined, size: 72, color: Colors.grey),
    );
  }
}
