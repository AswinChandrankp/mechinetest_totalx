import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget privacyPolicyLinkAndTermsOfService() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Center(
      child: Text.rich(
        TextSpan(
          text: 'By Continuing, I agree to TotalX’s', style: TextStyle(
          fontSize: 11, color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
          children: <TextSpan>[
            TextSpan(
              text: 'Terms and Conditions', style: TextStyle(
              fontSize: 11, color: Colors.blue,
               fontWeight: FontWeight.w600,
            ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                // code to open / launch terms of service link here
                }
            ),
            TextSpan(
              text: ' & ', style: TextStyle(
              fontSize: 11, color: Colors.black,
               fontWeight: FontWeight.w600,
            ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Privacy Policy', style: TextStyle(
                  fontSize: 11, color: Colors.blue,
                   fontWeight: FontWeight.w600,
                
                ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                    // code to open / launch privacy policy link here
                      }
                )
              ]
            )
          ]
        )
      )
      ),
    );
  }