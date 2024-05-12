

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mechinetest_totalx/model/newuser_model.dart';
import 'package:mechinetest_totalx/views/main/adduser.dart';
import 'package:provider/provider.dart';

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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddNewUserProvider()..getUsers(),
      child: Consumer<AddNewUserProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: const Icon(Icons.location_on),
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: provider.onSearchChanged,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (builder) => _buildFilterOptions(context, provider),
                          );
                        },
                        icon: Icon(Icons.filter_list),
                      )
                    ],
                  ),
                  Expanded(child: _buildUserList(provider)),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Colors.black,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      insetPadding: EdgeInsets.all(0),
                      child: const AddUser(),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterOptions(BuildContext context, AddNewUserProvider provider) {
    return Column(
      children: [
        CheckboxListTile(
          value: provider.showAllUsers,
          onChanged: (value) {
            provider.toggleShowAllUsers(value ?? false);
            Navigator.pop(context); // Close the bottom sheet after selection
          },
          title: Text("Show all users"),
        ),
        CheckboxListTile(
          value: provider.showElderUsers,
          onChanged: (value) {
            provider.toggleShowElderUsers(value ?? false);
            Navigator.pop(context); // Close the bottom sheet after selection
          },
          title: Text("Show elder users (>= 60)"),
        ),
        CheckboxListTile(
          value: provider.showYoungerUsers,
          onChanged: (value) {
            provider.toggleShowYoungerUsers(value ?? false);
            Navigator.pop(context); // Close the bottom sheet after selection
          },
          title: Text("Show younger users (< 60)"),
        ),
      ],
    );
  }

  Widget _buildUserList(AddNewUserProvider provider) {
    if (provider.filteredUsers.isEmpty) {
      return Center(child: Text("No users available"));
    }

    return ListView.builder(
      itemCount: provider.filteredUsers.length,
      itemBuilder: (context, index) {
        final user = provider.filteredUsers[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: user.image.isNotEmpty
                ? NetworkImage(user.image)
                : null,
            child: user.image.isEmpty
                ? Icon(Icons.person, size: 30)
                : null,
          ),
          title: Text(user.name),
          subtitle: Text(user.age ?? ""),
        );
      },
    );
  }
}

