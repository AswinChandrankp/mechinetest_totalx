
import 'package:flutter/material.dart';

// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final TextInputType keyboardType;
//   final String hintText;
//   final bool isRequired;
//   final String? Function(String?)? validator; // Validator function

//   const CustomTextField({
//     Key? key,
//     required this.controller,
//     required this.keyboardType,
//     required this.hintText,
//     this.isRequired = false,
//     this.validator, // Validator function parameter
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.centerRight,
//       children: [
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           decoration: InputDecoration(

//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
//             ),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             hintText: "$hintText",
//             border: OutlineInputBorder(


//               borderSide: BorderSide(color: Colors.grey[100]!, width: 1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           validator: validator,
//         ),
//         if (isRequired)
           
//           Padding(
//             padding:  EdgeInsets.only(right: hintText.length*10),
//             child: Text(
//               '*',
//               style: TextStyle(
//                 color: Colors.red,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
         
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final bool isRequired;
  final String? Function(String?)? validator; // Validator function

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    required this.hintText,
    this.isRequired = false,
    this.validator, // Validator function parameter
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isTextEntered = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_textChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_textChanged);
    super.dispose();
  }

  void _textChanged() {
    setState(() {
      isTextEntered = widget.controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[100]!, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: widget.validator,
        ),
        if (widget.isRequired && !isTextEntered)
          Padding(
            padding: EdgeInsets.only(right: widget.hintText.length * 10.0, bottom: 20),
            child: Text(
              '*',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
