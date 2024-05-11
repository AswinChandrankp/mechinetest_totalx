import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mechinetest_totalx/controller/authprovider.dart';
import 'package:mechinetest_totalx/views/main/home.dart';
import 'package:mechinetest_totalx/views/utils/utils.dart';
import 'package:mechinetest_totalx/views/widgets/custombutton.dart';

import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class Otpscreen extends StatefulWidget {
  final String verificationId;
  final String number;
  const Otpscreen({super.key, required this.verificationId, required this.number});

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
 String? otpcode;  

  @override
  Widget build(BuildContext context) 
  {
    final isloading = Provider.of<AuthProvider>(context , listen: true).isloading;
    return Scaffold(
      body: 
      // isloading ? Center(child: CircularProgressIndicator(),) :
        Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Align column children in the center
              children: [
                Image.asset( 'assets/images/image.png', 
                
                width: 130, height: 150,
                 ),
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text('OTP Verification', style: TextStyle(color: Colors.black, fontSize: 20),),

            

                ],),

                Row(
                  children: [
                    Text("Enter the verification code we just sent to your\nnumber ${widget.number}.")
                  ]   ),

                Pinput(
                  length: 6,
                  onCompleted: (value) {
                    print(value);

                    setState(() {
                      otpcode = value;
                    }
                    );
                  },
                  
                ),

                SizedBox(height: 20,),
                Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'Don\'t Get OTP?',
        style: TextStyle(
          fontSize: 11,
          color: Colors.black,
        ),
      ),
      TextSpan(
        text: 'resend',
        style: TextStyle(
          fontSize: 11,
          color: Colors.blue,
          fontWeight: FontWeight.w600,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            // Add your "resend OTP" functionality here
            // _resendOTP();
          },
      ),
    ],
  ),
),

SizedBox(height: 20,),

Row(
  children: [
    Expanded(
      
      child: CustomElevatedButton(
        color: Colors.black,
        text: "Verify",
       onPressed: () {
        if (otpcode != null) {
          verifyOTP(context, otpcode!);

        } else {
          showsnackbar(context, "Enter OTP");
        }
      }),
    ),
  ],
)
              ],
            ),
          ),
        ),
      ),
    );
  }



  void verifyOTP(BuildContext context , String otpcode) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOTP(context: context, verificationId: widget.verificationId, smsCode: otpcode, onSuccess: () {
    
         Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
       
    //  ap.signInWithPhone(context, widget.number);
      
    });
    

    
  }
}

