

import 'package:cloud_firestore/cloud_firestore.dart';

class newusermodel {
  String id;
  String name;
  String age;
  String image;
  String number;
  newusermodel({required this.name, required this.age, required this.image, required this.id, required this.number});

  factory newusermodel.fromJson(DocumentSnapshot json) {
    return newusermodel(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      image: json['image'],
      number: json['number'],


    );
    
    
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'image': image,
      'number': number

    };
  }
}

