import 'package:flutter/material.dart';

class sortbottomsheet extends StatelessWidget {
  const sortbottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Sort"),
          RadioListTile(value: 1, groupValue: 1, onChanged: (value) {}, title: Text("All")),
          RadioListTile(value: 1, groupValue: 1, onChanged: (value) {}, title: Text("Age :elder")),
          RadioListTile(value: 1, groupValue: 1, onChanged: (value) {}, title: Text("Age :younger")),
        ]
      ),
    );
  }
}