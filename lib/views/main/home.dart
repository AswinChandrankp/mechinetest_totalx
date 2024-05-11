import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mechinetest_totalx/controller/addnewuser_provider.dart';
import 'package:mechinetest_totalx/model/newuser_model.dart';
import 'package:mechinetest_totalx/views/main/adduser.dart';
import 'package:provider/provider.dart';



// class HomePage extends StatelessWidget {
//     HomePage({super.key});

//      AddNewUserProvider _newuuserservice = AddNewUserProvider();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: const Icon(Icons.location_on),
//       ),
//       body: Column(
//         children: [
//        Row(
//          children: [
              
//               TextField(
//                 onChanged: (value) {
//                     // SEARCH TEXTFIELD GOES HERE
//                 },
//                  controller: TextEditingController(),
//                 keyboardType: TextInputType.text,
//                 decoration: InputDecoration(
//                   hintText: "Search",
//                   prefixIcon: Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),


//                   )
//                 )
//               ),
            


//              SizedBox(height: 30,)
//          ]
//        ),

//           Container(
//             child: StreamBuilder<List<newusermodel>>(
//               stream: _newuuserservice.getusers(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.none) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Text(snapshot.error.toString());
//                 }
//                 if (snapshot.hasData && snapshot.data!.isEmpty) {
//                   return Center(child: Text("No users available"));
//                 }
//                 if (snapshot.hasData) {
//                   return Expanded(
//                     child: ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
            
//              final data = snapshot.data![index];
//               return ListTile(
                  
//                 leading: CircleAvatar(
//               backgroundImage: data.image.isNotEmpty
//                   ? NetworkImage(data.image)
//                   : null,
//               child: data.image.isEmpty
//                   ? const Icon(Icons.person, size: 30) // Change the icon as per your requirement
//                   : null,
//             ),
            
//                 title: Text(data.name),
//                 subtitle: Text(data.age),
//               );
//             },
//                     ),
//                   );
//                 }
//                 return Container(); // Add a default case to return a widget
//               },
//             ),
//           )

//         ],
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

  late Stream<List<newusermodel>> _usersStream;

  List<newusermodel> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _usersStream = _newuuserservice.getusers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

void _onSearchChanged() {
  String searchText = _searchController.text.toLowerCase();
  _usersStream.listen((users) {
    setState(() {
      _filteredUsers = users.where((user) {
        return user.name.toLowerCase().contains(searchText) ||
            user.age.toLowerCase().contains(searchText) ||
            user.number.contains(searchText);
      }).toList();
      print("Filtered Users: $_filteredUsers");
    });
  });
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(Icons.location_on),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
          Expanded(
            child: StreamBuilder<List<newusermodel>>(
              stream: _usersStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                List<newusermodel> users = snapshot.data!;
                if (_searchController.text.isNotEmpty) {
                  users = _filteredUsers;
                }
                if (users.isEmpty) {
                  return Center(child: Text("No users available"));
                }
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
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
                );
              },
            ),
          ),
        ],
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
