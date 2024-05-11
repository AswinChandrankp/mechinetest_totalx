




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
      width: MediaQuery.of(context).size.width,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text("Add New User"),
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
                        radius: 50,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.account_circle,
                          size: 100,
                          color: Colors.white,
                        ),
                      )
                    : Image.file(_image!), // Display selected image
              ),
            ),
            const Text("Name"),
            Customtextfield(
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
             const Text("Number"),
            Customtextfield(
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
            const Text("Age"),
            Customtextfield(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Row(
                    children: [
                      CustomElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Cancel button action
                        },
                        text: 'Cancel',
                      ),
                      CustomElevatedButton(
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
    );
  }

  void _addNewUser(BuildContext context) async {
    final String id = Uuid().v1();
    final String name = _nameController.text;
    final String age = _ageController.text;
    final String number = _numberController.text;


    if (name.isNotEmpty && age.isNotEmpty) {
      final newusermodel newUser = newusermodel(
        id: id,
        name: name,
        age: age,
        image: _image?.path ?? '', 
        number: number
        // Handle image path if image is selected
      );

      try {
        final AddNewUserProvider addNewUserProvider =
            Provider.of<AddNewUserProvider>(context, listen: false);
        await addNewUserProvider.createUser(newUser);
        showsnackbar(context, "User Added");
        Navigator.pop(context); // Close AddUser screen after user is added
      } catch (e) {
        print('Error adding user: $e');
        showsnackbar(context, "Error adding user");
      }
    }
  }
}
