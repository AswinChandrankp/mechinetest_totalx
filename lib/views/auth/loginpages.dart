


// import 'package:flutter/material.dart';
// import 'package:mechinetest_totalx/controller/authprovider.dart';
// import 'package:mechinetest_totalx/views/constant.dart';
// import 'package:mechinetest_totalx/views/widgets/custombutton.dart';
// import 'package:mechinetest_totalx/views/widgets/customtextfield.dart';
// import 'package:mechinetest_totalx/views/widgets/privacy&policy.dart';
// import 'package:provider/provider.dart';

// class Loginpage extends StatefulWidget {
//   Loginpage({Key? key}) : super(key: key);

//   @override
//   State<Loginpage> createState() => _LoginpageState();
// }

// class _LoginpageState extends State<Loginpage> {
//   TextEditingController numberController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(defaultpadding),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset('assets/images/image1.png',
//                     width: MediaQuery.of(context).size.width * 0.5,
//                     height: MediaQuery.of(context).size.height * 0.4),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(defaultpadding),
//                       child: Text(
//                         "Enter Phone Number",
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ],
//                 ),

//                 CustomTextField(
//                   controller: numberController,
//                   keyboardType: TextInputType.number,
//                   hintText: 'Enter Phone Number',
//                   isRequired: true,
//                   validator: (value) {
//                     if (value!.isEmpty) {

//                       return 'Please enter a valid phone number';

//                     }
//                   }
//                 ),
            
//                 privacyPolicyLinkAndTermsOfService(),
//                 SizedBox(height: defaultpadding),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomElevatedButton(
//                         borderRadius: 25,
//                         padding: EdgeInsets.symmetric(vertical: 15),
//                         color: Colors.black,
//                         text: "Get OTP",
//                         onPressed: () {
//                           sendPhoneNumber();
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

 
//   void sendPhoneNumber() {
//   final authProvider = Provider.of<AuthProvider>(context, listen: false);
//   String phoneNumber = numberController.text.trim();
//   print('Phone number submitted: $phoneNumber');
//   authProvider.signInWithPhone(context, "+91$phoneNumber");
// }

// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mechinetest_totalx/controller/authprovider.dart';
import 'package:mechinetest_totalx/views/constant.dart';
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
  GlobalKey<FormState> numberformKey = GlobalKey<FormState>(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         systemOverlayStyle: SystemUiOverlayStyle(
    // Status bar color
    statusBarColor: Colors.black, 

    // Status bar brightness (optional)
    statusBarIconBrightness: Brightness.light, // For Android (dark icons)
    statusBarBrightness: Brightness.light, // For iOS (dark icons)
  ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(defaultpadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/image1.png',
                  width: MediaQuery.of(context).size.width * 0.5,
                  // height: MediaQuery.of(context).size.height * 0.4,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(defaultpadding),
                      child: Text(
                        "Enter Phone Number",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),

               
                Form(
                  key: numberformKey,
                  child: CustomTextField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    hintText: 'Enter Phone Number',
                    isRequired: true,
                    validator: (value) {
                      if (value!.isEmpty || !isValidPhoneNumber(value)) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                ),

                privacyPolicyLinkAndTermsOfService(),
                SizedBox(height: defaultpadding),
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        borderRadius: 25,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        color: Colors.black,
                        text: "Get OTP",
                        onPressed: () {
                          if (numberformKey.currentState!.validate()) {
                            sendPhoneNumber();
                          }
                        },
                      ),
                    ),
                  ],
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

 
  bool isValidPhoneNumber(String value) {
    
    return value.length == 10; 
  }
}
