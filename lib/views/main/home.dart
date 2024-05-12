import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mechinetest_totalx/controller/addnewuser_provider.dart';
import 'package:mechinetest_totalx/model/newuser_model.dart';
import 'package:mechinetest_totalx/views/main/adduser.dart';
import 'package:mechinetest_totalx/views/main/sort.dart';
import 'package:provider/provider.dart';






// class HomePage extends StatefulWidget {
//   HomePage({Key? key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   AddNewUserProvider _newuuserservice = AddNewUserProvider();

//   TextEditingController _searchController = TextEditingController();

//   late Stream<List<newusermodel>> _usersStream;

//   List<newusermodel> _filteredUsers = [];

//   @override
//   void initState() {
//     super.initState();
//     _usersStream = _newuuserservice.getusers();
//     _searchController.addListener(_onSearchChanged);
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }


// void _onSearchChanged() {
//   String searchText = _searchController.text.toLowerCase();
//   _newuuserservice.getusers().listen((users) {
//     setState(() {
//       _filteredUsers = users.where((user) {
//         return user.name.toLowerCase().contains(searchText) ||
//             user.age.toLowerCase().contains(searchText) ||
//             user.number.contains(searchText);
//       }).toList();
//       print("Filtered Users: $_filteredUsers");
//     });
//   });
// }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: const Icon(Icons.location_on),
//       ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
                    
//                     controller: _searchController,
//                     keyboardType: TextInputType.text,
//                     decoration: InputDecoration(
//                       hintText: "Search",
//                       prefixIcon: Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     showModalBottomSheet(context: context, builder: (builder) => sortbottomsheet());
//                   }
//                   , icon: Icon(Icons.filter_list),
//                 )
//               ],
//             ),
//             Expanded(
//               child: StreamBuilder<List<newusermodel>>(
//                 stream: _usersStream,
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   List<newusermodel> users = snapshot.data!;
//                   if (_searchController.text.isNotEmpty) {
//                     users = _filteredUsers;
//                   }
//                   if (users.isEmpty) {
//                     return Center(child: Text("No users available"));
//                   }
//                   return ListView.builder(
//                     itemCount: users.length,
//                     itemBuilder: (context, index) {
//                       final user = users[index];
//                       return ListTile(
//                         leading: CircleAvatar(
//                           backgroundImage: user.image.isNotEmpty
//                               ? NetworkImage(user.image)
//                               : null,
//                           child: user.image.isEmpty
//                               ? Icon(Icons.person, size: 30)
//                               : null,
//                         ),
//                         title: Text(user.name),
//                         subtitle: Text(user.age),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         shape: const CircleBorder(),
//         backgroundColor: Colors.black,
//         child: const Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return Dialog(
//                 insetPadding: EdgeInsets.all(0),
//                 child: const AddUser(),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
class HomePage extends StatefulWidget {
  HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AddNewUserProvider _newuuserservice = AddNewUserProvider();

  TextEditingController _searchController = TextEditingController();

  late StreamSubscription<List<newusermodel>> _usersSubscription;

  List<newusermodel> _users = [];
  List<newusermodel> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _usersSubscription = _newuuserservice.getusers().listen((users) {
      setState(() {
        _users = users;
        _filteredUsers = users;
      });
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _usersSubscription.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _users.where((user) {
        return user.name.toLowerCase().contains(searchText) ||
            user.age.toLowerCase().contains(searchText) ||
            user.number.contains(searchText);
      }).toList();
    });
  }

  void _sortUsersByAge(String sortOrder) {
    setState(() {
      if (sortOrder == 'asc') {
        _filteredUsers.sort((a, b) => a.age.compareTo(b.age));
      } else {
        _filteredUsers.sort((a, b) => b.age.compareTo(a.age));
      }
    });
  }

  Widget sortbottomsheet() {
    return Container(
      height: 150,
      child: Column(
        children: [
          ListTile(
            title: Text('Sort by Age'),
            onTap: () {
              _sortUsersByAge('asc');
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Sort by Age (Descending)'),
            onTap: () {
              _sortUsersByAge('desc');
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    controller: _searchController,
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
                      builder: (builder) => sortbottomsheet(),
                    );
                  },
                  icon: Icon(Icons.filter_list),
                )
              ],
            ),
           Expanded(
              child: _filteredUsers.isEmpty
                 ? Center(child: Text("No users available"))
                  : ListView.builder(
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
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
                          subtitle: Text(user.age),
                        );
                      },
                    ),
            ),
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
  }
}