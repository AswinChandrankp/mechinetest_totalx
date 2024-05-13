


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mechinetest_totalx/controller/addnewuser_provider.dart';
import 'package:mechinetest_totalx/model/newuser_model.dart';
import 'package:mechinetest_totalx/views/utils/utils.dart';
import 'package:mechinetest_totalx/views/widgets/custombutton.dart';
import 'package:mechinetest_totalx/views/widgets/customtextfield.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  File? _image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
   final TextEditingController _numberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final image = await pickImage(context);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
      height: 450,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),

      ),
      // width: MediaQuery.of(context).size.width * 0.95,
      // height: MediaQuery.of(context).size.height*0.6,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text("Add New User",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    _selectImage();
                    
                  },
                  child: _image == null
                      ? const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.account_circle,
                            size: 80,
                            color: Colors.white,
                          ),
                        )
                      :  CircleAvatar(
                          radius: 40,
                          backgroundImage:  FileImage(File(_image!.path))  ,
                          
                        ),
                     
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(8.0),
                child: const Text("Name",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xFF333333)),),
              ),
              
              CustomTextField(
                
                controller: _nameController,
                keyboardType: TextInputType.text,
                hintText: "Name",
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter a name';
                //   }
                //   return null;
                // },
              ),
               Padding(
                padding: EdgeInsets.all(8.0),
            
                 child: const Text("Number",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xFF333333)),),
               ),
              CustomTextField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                hintText: "Number",
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter an age';
                //   }
                //   return null;
                // },
              ),
              Padding(
                  padding: EdgeInsets.all(8.0),
                child: const Text("Age",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xFF333333)),),
              ),
              CustomTextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                hintText: "Age",
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter an age';
                //   }
                //   return null;
                // },
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Row(
                      children: [
                        CustomElevatedButton(
                          borderRadius: 8,
                          color: Color(0xFFCCCCCC),
                          onPressed: () {
                            Navigator.pop(context); // Cancel button action
                          },
                          text: 'Cancel',
                        ),
                        SizedBox(width: 10),
                        CustomElevatedButton(
                          borderRadius: 8,
                          color: Color(0xFF1782FF),
                          onPressed: () {
                            _addNewUser(context);
                          },
                          // onPressed: () {
                          //   if (_formKey.currentState!.validate()) {
                          //     _addNewUser();
                          //   }
                          // },
                          text: 'Submit',
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


Future<void> _addNewUser(BuildContext context) async {
  
  if (_formKey.currentState!.validate()) {
    final String id = Uuid().v1();
    final String name = _nameController.text;
    final String age = _ageController.text;
    final String number = _numberController.text;

   
  
// if (_formKey.currentState!.validate() == null) {
//      showsnackbar(context, "Enter Details");
//      return;
     
//    }

    if (_image == null) {
      showsnackbar(context, "Please select an image");
      return;
      
    }
    final newUser = newusermodel(
      id: id,
      name: name,
      age: age,
      image: _image !.path,
      number: number,
    );

     

    try {
      print('Adding user: $newUser');
      
      final addNewUserProvider =
          Provider.of<AddNewUserProvider>(context, listen: false);
      await addNewUserProvider.createUser(newUser);
      showsnackbar(context, "User Added");

      // Update the list after adding the new user
      addNewUserProvider.getUsers();

      Navigator.pop(context); 
    } catch (e) {
      print('Error adding user: $e');
      showsnackbar(context, "Error adding user");
    }
  }
}
}