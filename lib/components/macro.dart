import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyMacroWidget extends StatelessWidget {
  final String title;
  final int value;
  const MyMacroWidget({required this.title, required this.value, super.key});

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
              Icon(CupertinoIcons.airplane, color: Colors.redAccent),
              const SizedBox(height: 4,),
              Text('$value $title', style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
