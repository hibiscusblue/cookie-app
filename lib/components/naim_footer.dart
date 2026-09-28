import 'package:flutter/material.dart';

class NaimFooter extends StatelessWidget {
  const NaimFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Colors.black.withValues(alpha: 0.06),
              width: 0.5,
            ),
          ),
        ),
        child: Text(
          '© 2026 NAIM  ·  Your Moment of Bliss',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 0.5,
            color: Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}