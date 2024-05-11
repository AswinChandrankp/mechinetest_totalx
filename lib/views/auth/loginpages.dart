


import 'package:flutter/material.dart';
import 'package:mechinetest_totalx/controller/authprovider.dart';
import 'package:mechinetest_totalx/views/widgets/custombutton.dart';
import 'package:mechinetest_totalx/views/widgets/customtextfield.dart';
import 'package:mechinetest_totalx/views/widgets/privacy&policy.dart';
import 'package:provider/provider.dart';

class Loginpage extends StatefulWidget {
  Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/image1.png'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Enter Phone Number",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Customtextfield(
                  keyboardType: TextInputType.number,
                  hintText: 'Enter Phone Number',
                  controller: numberController,
                ),
                privacyPolicyLinkAndTermsOfService(),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          borderRadius: 25,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          color: Colors.black,
                          text: "Get OTP",
                          onPressed: () {
                            sendPhoneNumber();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 
  void sendPhoneNumber() {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  String phoneNumber = numberController.text.trim();
  print('Phone number submitted: $phoneNumber');
  authProvider.signInWithPhone(context, "+91$phoneNumber");
}

}
