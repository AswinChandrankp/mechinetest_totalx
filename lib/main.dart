import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mechinetest_totalx/controller/addnewuser_provider.dart';
import 'package:mechinetest_totalx/controller/authprovider.dart';
import 'package:mechinetest_totalx/views/auth/loginpages.dart';
import 'package:provider/provider.dart';


void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: 
    [
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => AddNewUserProvider())

    ],
    
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
  textTheme: GoogleFonts.montserratTextTheme(),
),

      
      home: Loginpage(),
    ),
    );
    
  }
}
