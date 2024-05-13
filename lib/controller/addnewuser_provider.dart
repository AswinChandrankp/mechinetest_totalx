


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mechinetest_totalx/model/newuser_model.dart';

class AddNewUserProvider extends ChangeNotifier {
  final CollectionReference _newUserCollection =
      FirebaseFirestore.instance.collection('Newuser');

      

  

  List<newusermodel> _users = [];
  List<newusermodel> _filteredUsers = [];
  bool _showAllUsers = true;
  bool _showElderUsers = false;
  bool _showYoungerUsers = false;

  List<newusermodel> get users => _users;
  List<newusermodel> get filteredUsers => _filteredUsers;
  bool get showAllUsers => _showAllUsers;
  bool get showElderUsers => _showElderUsers;
  bool get showYoungerUsers => _showYoungerUsers;

  

  Future<void> createUser(newusermodel newUser) async {
  try {
    final newUserData = newUser.toJson();
    await _newUserCollection.doc(newUser.id).set(newUserData);
    getUsers(); // Update the list after adding the new user
    notifyListeners();
    filteredUsers.add(newUser);
  } catch (e) {
    print(e.toString());
    rethrow;
  }
}


  Future<void> getUsers() async {
  try {
    final QuerySnapshot snapshot = await _newUserCollection.get();
    _users = snapshot.docs.map((doc) => newusermodel.fromJson(doc)).toList();
    _filteredUsers = _users;
    notifyListeners();
  } catch (e) {
    print(e.toString());
    notifyListeners();
    rethrow;
  }
}

  void onSearchChanged(String searchText) {

    _filteredUsers = _users.where((user) {
      return user.name.toLowerCase().contains(searchText) ||
          (user.age != null && user.age!.toLowerCase().contains(searchText)) ||
          user.number.contains(searchText);
    }).toList();
    notifyListeners();

  }

  void sortUsersByAge() {
    if (_showAllUsers) {
      _filteredUsers.sort((a, b) => (a.age != null && b.age != null) ? int.parse(a.age!) - int.parse(b.age!) : 0);
    } else if (_showElderUsers) {
      _filteredUsers.sort((a, b) => (a.age != null && b.age != null) ? int.parse(a.age!) - int.parse(b.age!) : 0);
    } else if (_showYoungerUsers) {
      _filteredUsers.sort((a, b) => (a.age != null && b.age != null) ? int.parse(b.age!) - int.parse(a.age!) : 0);
    }
    notifyListeners();
  }

  void toggleShowAllUsers(bool value) {
    _showAllUsers = value;
    _showElderUsers = false;
    _showYoungerUsers = false;
    if (value) {
      _filteredUsers = _users;
    } else {
      _filteredUsers = _users.where((user) => user.age != null).toList();
    }
    sortUsersByAge();
    notifyListeners();
  }

  void toggleShowElderUsers(bool value) {
    _showElderUsers = value;
    _showAllUsers = false;
    _showYoungerUsers = false;
    _filteredUsers = _users.where((user) => user.age != null && int.parse(user.age!) >= 60).toList();
    sortUsersByAge();
    notifyListeners();
  }

  void toggleShowYoungerUsers(bool value) {
    _showYoungerUsers = value;
    _showAllUsers = false;
    _showElderUsers = false;
    _filteredUsers = _users.where((user) => user.age != null && int.parse(user.age!) < 60).toList();
    sortUsersByAge();
    notifyListeners();
  }
}

