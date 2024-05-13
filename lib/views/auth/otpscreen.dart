import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mechinetest_totalx/controller/authprovider.dart';
import 'package:mechinetest_totalx/views/constant.dart';
import 'package:mechinetest_totalx/views/main/home.dart';
import 'package:mechinetest_totalx/views/utils/utils.dart';
import 'package:mechinetest_totalx/views/widgets/custombutton.dart';
import 'package:mechinetest_totalx/views/widgets/timer.dart';

import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class Otpscreen extends StatefulWidget {
  final String verificationId;
  final String number;
  const Otpscreen(
      {super.key, required this.verificationId, required this.number});

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}GlobalKey<ResendOTPTimerState> _key = GlobalKey<ResendOTPTimerState>();

class _OtpscreenState extends State<Otpscreen> {

  
  String? otpcode;

  @override
  Widget build(BuildContext context) {
    final isloading =
        Provider.of<AuthProvider>(context, listen: true).isloading;
    return Scaffold(
      body:
          // isloading ? Center(child: CircularProgressIndicator(),) :
          Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(defaultpadding * 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Align column children in the center
              children: [
                Image.asset(
                  'assets/images/image.png',
                  width: 130,
                  height: 150,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OTP Verification',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Text(
                    "Enter the verification code we just sent to your\nnumber ${hashPhoneNumber(widget.number)}.",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ]),
                SizedBox(
                  height: 20,
                ),
                Pinput(
                  defaultPinTheme: PinTheme(
                      textStyle: TextStyle(color: Colors.red),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      )),
                  followingPinTheme: PinTheme(
                      textStyle: TextStyle(color: Colors.red),
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      )),
                  disabledPinTheme: PinTheme(
                    textStyle: TextStyle(color: Colors.red),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                      textStyle: TextStyle(color: Colors.red),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      )),
                  focusNode: FocusNode(),
                  length: 6,
                  onCompleted: (value) {
                    print(value);

                    setState(() {
                      otpcode = value;
                    });
                  },
                ),
                SizedBox( height: 10, ),
                ResendOTPTimer(key: _key,),
                SizedBox(
                  height: 20,
                ),
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
                    setState(() {
                             _key.currentState?.resetTimer(); 
                           });
                             
                          },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        borderRadius: 60,
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

  void verifyOTP(BuildContext context, String otpcode) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOTP(
        context: context,
        verificationId: widget.verificationId,
        smsCode: otpcode,
        onSuccess: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );

          //  ap.signInWithPhone(context, widget.number);
        });
  }

  String hashPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 4) return phoneNumber;
    return '+91${'*' * 8}${phoneNumber.substring(phoneNumber.length - 2)}';
  }

  
}



