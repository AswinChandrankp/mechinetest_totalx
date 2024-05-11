import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showsnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}



Future<File?> pickImage( BuildContext context) async {

  File? image;

  try {
    
    final pickedimage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      image = File(pickedimage.path);
    }
  }catch (e) {
    showsnackbar(context, e.toString());
  }
  
  return image;
}