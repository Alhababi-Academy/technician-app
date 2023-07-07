import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technicianApp/Authentication/register.dart';
import 'package:technicianApp/DialogBox/errorDialog.dart';
import 'package:technicianApp/DialogBox/loadingDialog.dart';
import 'package:technicianApp/Widgets/customTextField.dart';
import 'package:technicianApp/config/config.dart';
import 'package:technicianApp/technicianAuth/registerStation.dart';
import 'package:technicianApp/technisianHomePages/technicianHomePage.dart';
import 'package:technicianApp/userHomePages/homePage.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPassword createState() => _ForgetPassword();
}

class _ForgetPassword extends State<ForgetPassword> {
  final TextEditingController _emailTextEditingController =
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
                "Reset Password",
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
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _emailTextEditingController.text.isNotEmpty
                    ? loginUser()
                    : showDialog(
                        context: context,
                        builder: (c) {
                          return const ErrorAlertDialog(
                            message: "Please write Email",
                          );
                        });
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue,
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Send",
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
        ?.sendPasswordResetEmail(
      email: _emailTextEditingController.text.trim(),
    )
        .then((authUser) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (_) => ErrorAlertDialog(message: "Email were sent"));
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
}
