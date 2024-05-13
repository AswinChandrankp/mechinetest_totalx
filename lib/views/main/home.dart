

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mechinetest_totalx/controller/addnewuser_provider.dart';
import 'package:mechinetest_totalx/model/newuser_model.dart';
import 'package:mechinetest_totalx/views/constant.dart';
import 'package:mechinetest_totalx/views/main/adduser.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddNewUserProvider()..getUsers(),
      child: Consumer<AddNewUserProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: primarycolor,
            appBar: AppBar(
               toolbarHeight: 70,
               systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: Colors.white, 
    
    statusBarIconBrightness: Brightness.dark, 
    statusBarBrightness: Brightness.dark, 
  ),
              backgroundColor: Colors.black,
              leadingWidth: 300,
              leading: Container(
                child: Padding(
                  padding: const EdgeInsets.all(defaultpadding),
                  child: Row(
                    children: [
                      
                      Icon(Icons.location_on,color: Colors.white,size: 20,),
                      Expanded(
                        child: Text(
                          textDirection: TextDirection.ltr ,
                          "Nilambur",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500),
                        ),
                      )
                    ]
                  ),
                ),
              ),
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only( left: defaultpadding,top: defaultpadding,bottom: defaultpadding),
                          child: TextField(
                            
                            onChanged: provider.onSearchChanged,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                               contentPadding: EdgeInsets.only(left: 15),
                               
                              hintText: "Search by name",
                              prefixIcon: Icon(Icons.search ,color: Colors.black,),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(36),
                              ),
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
                  Padding(
                    padding: const EdgeInsets.all(defaultpadding),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("User List",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),),
                      ],
                    ),
                  ),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildUserList(provider),
                  )),
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
                ).then((value) {
                  // Refresh the user list after the dialog is closed
                  provider.getUsers();
                });
              },
            ),
          );
        },
      ),
    );
  }


Widget _buildFilterOptions(BuildContext context, AddNewUserProvider provider) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.3,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Sort"),
        RadioListTile<bool>(
          value: true,
          groupValue: provider.showAllUsers,
          onChanged: (value) {
            if (value != null) {
              provider.toggleShowAllUsers(value);
              Navigator.pop(context); // Close the bottom sheet after selection
            }
          },
          title: Text("Show all users"),
        ),
        RadioListTile<bool>(
          value: true,
          groupValue: provider.showElderUsers,
          onChanged: (value) {
            if (value != null) {
              provider.toggleShowElderUsers(value);
              Navigator.pop(context); // Close the bottom sheet after selection
            }
          },
          title: Text("Show elder users (>= 60)"),
        ),
        RadioListTile<bool>(
          value: true,
          groupValue: provider.showYoungerUsers,
          onChanged: (value) {
            if (value != null) {
              provider.toggleShowYoungerUsers(value);
              Navigator.pop(context); // Close the bottom sheet after selection
            }
          },
          title: Text("Show younger users (< 60)"),
        ),
      ],
    ),
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
        return Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, 3),
                 
                  
                )
              ]
          
            ),
            child: Row(
              children: [
                 CircleAvatar(
              radius: 30,
              backgroundImage: user.image.isNotEmpty
                  ? FileImage(File(user.image))
                  : null,
              child: user.image.isEmpty
                  ? Icon(Icons.person, size: 30)
                  : null,
            ),
          
            Padding(
              padding: const EdgeInsets.all(defaultpadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name,style: TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600),),
                  SizedBox(height: 5,),
                  Text("Age:${user.age}"?? "",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w500),),
                ]
              ),
            )
              ]
            ),
            
          ),
        );
      },
    );
  }
}


// leading: CircleAvatar(
//             radius: 50,
//             backgroundImage: user.image.isNotEmpty
//                 ? FileImage(File(user.image))
//                 : null,
//             child: user.image.isEmpty
//                 ? Icon(Icons.person, size: 30)
//                 : null,
//           ),
//           title: Text(user.name),
//           subtitle: Text(user.age ?? ""),