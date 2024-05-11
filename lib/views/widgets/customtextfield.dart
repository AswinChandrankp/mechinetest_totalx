import 'package:flutter/material.dart';

class Customtextfield extends StatelessWidget {
  final controller;
  final keyboardType;
  final String hintText;
  const Customtextfield({super.key, required this.keyboardType, required this.hintText, this.controller,});

  @override
  Widget build(BuildContext context) {
    return TextField(
    controller:controller ,
     
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          

        )
      )
    );
  }
}