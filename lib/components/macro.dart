import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyMacroWidget extends StatelessWidget {
  final String title;
  final int value;
  final FaIconData icon;
  final Color iconColor;
  const MyMacroWidget({required this.title, required this.value, required this.icon, super.key, required this.iconColor,});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              offset: const Offset(2, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FaIcon(icon, color: iconColor,),
              const SizedBox(height: 4,),
              Text(
                title == "Calories" ? '$value $title' : '${value}g $title',
                style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
