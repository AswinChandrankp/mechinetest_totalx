
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mechinetest_totalx/model/newuser_model.dart';

class AddNewUserProvider extends ChangeNotifier {
  final CollectionReference _newUserCollection =
      FirebaseFirestore.instance.collection('Newuser');

  Future<void> createUser(newusermodel newUser) async {
    try {
      final newUserData = newUser.toJson();
      await _newUserCollection.doc(newUser.id).set(newUserData);
    } catch (e) {
      print(e.toString());
      
      throw e;
    }
  }

   Stream<List<newusermodel>> getusers() {

    try {

      return _newUserCollection.snapshots().map((QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot doc) {
          return newusermodel.fromJson(doc);
        }).toList();
        
      });
      
    }catch (e) {
      print(e.toString());
      throw e;
    }
    
  }

  // Future <List<newusermodel>?>getAllusers() async {
  //   try {
  //     final Stream<QuerySnapshot<Object?>> user = await _newUserCollection.snapshots();
  //     final List<newusermodel> users = querySnapshot.docs.map((doc) {
  //       return newusermodel.fromJson(doc);
  //     }).toList();
  //     return users;
  //   } on FirebaseException catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
    
  // }
}