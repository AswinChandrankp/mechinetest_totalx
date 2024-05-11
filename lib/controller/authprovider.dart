

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mechinetest_totalx/views/auth/otpscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSigned = false;
  bool get isSigned => _isSigned;

   bool _isloading = false;
  bool get isloading => _isloading;

  String? _userId;
  String get userId => _userId!; 

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore= FirebaseFirestore.instance;


  AuthProvider() {
    checkSigned();
  }

  void checkSigned() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSigned = prefs.getBool('isSigned') ?? false;
    notifyListeners();
  }


  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      print('Phone number received for verification: $phoneNumber');
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (FirebaseAuthException error) {
          // Throw FirebaseAuthException instead of generic Exception
          throw FirebaseAuthException(code: error.code, message: error.message);
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          // Use Navigator.push instead of Navigator.of(context).push
          print('Verification ID sent: $verificationId');
          Navigator.push(context, MaterialPageRoute(builder: (context) => Otpscreen(verificationId: verificationId, number: phoneNumber,)));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle code auto retrieval timeout if needed
          print('Code auto retrieval timeout for verification ID: $verificationId');
        },
      );
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message.toString());
    }
  }

 


    void verifyOTP({
      required BuildContext context, 
      required String verificationId,
       required String smsCode,
       required Function onSuccess
       }) async {
       
      _isloading = true;
      notifyListeners();
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
        User? user = (await _auth.signInWithCredential(credential)).user!; 
        if(user != null){
           onSuccess();
           _userId = user.uid;
        }
        _isloading = false;
        notifyListeners();
       
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isSigned', true);
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        showSnackbar(context, e.message.toString());
        _isloading = false;
        notifyListeners();
      } finally {
        _isloading = false;
        notifyListeners();
      }
      
    }
  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }


  // database operation 
  Future<bool>CheckExistinguser() async {
     DocumentSnapshot documentSnapshot = await _firebaseFirestore.collection('users').doc(_userId).get();
    if(documentSnapshot.exists){
      print("user exists");
      return true;
    }else{
      print("New User");
      return false;
    }
  }
}
