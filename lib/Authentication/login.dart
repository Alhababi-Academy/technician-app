import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technicianApp/Authentication/ForgetPassword.dart';
import 'package:technicianApp/Authentication/register.dart';
import 'package:technicianApp/DialogBox/errorDialog.dart';
import 'package:technicianApp/DialogBox/loadingDialog.dart';
import 'package:technicianApp/Widgets/customTextField.dart';
import 'package:technicianApp/config/config.dart';
import 'package:technicianApp/technicianAuth/registerStation.dart';
import 'package:technicianApp/technisianHomePages/technicianHomePage.dart';
import 'package:technicianApp/userHomePages/homePage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return Material(
      child: Container(
        padding: EdgeInsets.all(7),
        color: Colors.blue.shade300,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              child: Image.asset(
                "img/r1.png",
                height: 200.0,
                width: 200.0,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Login in",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.lock,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _emailTextEditingController.text.isNotEmpty &&
                        _passwordTextEditingController.text.isNotEmpty
                    ? loginUser()
                    : showDialog(
                        context: context,
                        builder: (c) {
                          return const ErrorAlertDialog(
                            message: "Please write Email and Password",
                          );
                        });
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue,
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => Register());
                Navigator.push(context, route);
              },
              icon: const Icon(Icons.account_box, color: Colors.white),
              label: const Text("Register?",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            TextButton.icon(
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (c) => ForgetPassword());
                Navigator.push(context, route);
              },
              icon: const Icon(Icons.account_box, color: Colors.white),
              label: const Text("Forget Password?",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void loginUser() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) {
          return const LoadingAlertDialog(
            message: "Authenticating, Please wait...",
          );
        });
    await technicianApp.auth
        ?.signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((authUser) {
      technicianApp.userUID = authUser.user!.uid;
      print("This is the user IDDD ${technicianApp.userUID}");
      if (technicianApp.userUID != null) {
        loginInData(technicianApp.userUID);
      }
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
  }

  Future loginInData(String user) async {
    await technicianApp.firestore!
        .collection("users")
        .doc(user)
        .get()
        .then((snapshot) async {
      if (snapshot.data()!['role'] == "user") {
        await technicianApp.sharedPreferences
            ?.setString(technicianApp.userUID, user);

        await technicianApp.sharedPreferences
            ?.setString(technicianApp.role, snapshot.data()!['role']);

        await technicianApp.sharedPreferences
            ?.setString(technicianApp.userName, snapshot.data()!['name']);

        await technicianApp.sharedPreferences
            ?.setString(technicianApp.userEmail, snapshot.data()!['email']);

        await technicianApp.sharedPreferences
            ?.setString(technicianApp.location, snapshot.data()!['location']);

        await technicianApp.sharedPreferences
            ?.setString(technicianApp.imageUrl, snapshot.data()!['url']);

        Route route = MaterialPageRoute(builder: (c) => homePage());
        Navigator.pushReplacement(context, route);
      }
      if (snapshot.data()!['role'] == "technician") {
        await technicianApp.sharedPreferences
            ?.setString(technicianApp.TechnicianuserUID, user);

        await technicianApp.sharedPreferences
            ?.setString(technicianApp.role, snapshot.data()!['role']);

        await technicianApp.sharedPreferences
            ?.setString(technicianApp.TechnicianName, snapshot.data()!['name']);

        await technicianApp.sharedPreferences?.setString(
            technicianApp.TechnicianEmail, snapshot.data()!['email']);

        await technicianApp.sharedPreferences
            ?.setString(technicianApp.location, snapshot.data()!['location']);

        await technicianApp.sharedPreferences
            ?.setString(technicianApp.TechnicianUrl, snapshot.data()!['url']);
        Route route = MaterialPageRoute(builder: (c) => technicianHomePage());
        Navigator.pushReplacement(context, route);
      }
    });
  }
}
