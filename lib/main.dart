import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technicianApp/Authentication/authenication.dart';
import 'package:technicianApp/Authentication/login.dart';
import 'package:technicianApp/config/config.dart';
import 'package:technicianApp/splashScreen/splashScreen.dart';
import 'package:technicianApp/technisianHomePages/technicianHomePage.dart';
import 'package:technicianApp/userHomePages/homePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  technicianApp.sharedPreferences = await SharedPreferences.getInstance();
  technicianApp.auth = FirebaseAuth.instance;
  technicianApp.firestore = FirebaseFirestore.instance;
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.amberAccent),
      home: splashScreen(),
    );
  }
}
