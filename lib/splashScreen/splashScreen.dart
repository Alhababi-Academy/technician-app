import 'dart:async';
import 'package:flutter/material.dart';
import 'package:technicianApp/Authentication/login.dart';
import 'package:technicianApp/config/config.dart';
import 'package:technicianApp/technisianHomePages/technicianHomePage.dart';
import 'package:technicianApp/userHomePages/homePage.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  bool loading = false;

  @override
  // when page open frist thing to do
  void initState() {
    timeFunctoni();
    super.initState();
  }

  timeFunctoni() {
    setState(() {
      loading = true;
    });
    Timer(
      const Duration(seconds: 4),
      () async {
        if (loading == true) {
          if (technicianApp.auth?.currentUser != null) {
            String? currentUser = technicianApp.auth!.currentUser!.uid;
            await technicianApp.firestore!
                .collection("users")
                .doc(currentUser)
                .get()
                .then((result) {
              if (result.data()!.isNotEmpty) {
                String role = result.data()!['role'];
                switch (role) {
                  case "technician":
                    Route route =
                        MaterialPageRoute(builder: (_) => technicianHomePage());
                    Navigator.pushAndRemoveUntil(
                        context, route, (route) => false);
                    break;
                  case "user":
                    Route route = MaterialPageRoute(builder: (_) => homePage());
                    Navigator.pushAndRemoveUntil(
                        context, route, (route) => false);
                    break;
                }
              }
            });
          } else {
            Route route = MaterialPageRoute(builder: (_) => Login());
            Navigator.pushAndRemoveUntil(context, route, (route) => false);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("img/r1.png"),
            const Text(
              "Welcome to Technician Mobile Application",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            loading == true ? CircularProgressIndicator() : const Text("")
          ],
        ),
      ),
    );
  }
}
