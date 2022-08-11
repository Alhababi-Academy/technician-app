// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:technicianApp/DialogBox/errorDialog.dart';
// import 'package:technicianApp/DialogBox/loadingDialog.dart';
// import 'package:technicianApp/Widgets/customTextField.dart';
// import 'package:technicianApp/config/config.dart';
// import 'package:technicianApp/stationHomePages/servicesPage.dart';
// import 'package:technicianApp/stationHomePages/stationHomePage.dart';
// import 'package:technicianApp/technicianAuth/registerStation.dart';
// import 'package:technicianApp/userHomePages/homePage.dart';

// class stationLogin extends StatefulWidget {
//   @override
//   _stationLogin createState() => _stationLogin();
// }

// class _stationLogin extends State<stationLogin> {
//   final TextEditingController _emailTextEditingController =
//       TextEditingController();
//   final TextEditingController _passwordTextEditingController =
//       TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     double _screenWidth = MediaQuery.of(context).size.width,
//         _screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Technisian Login",
//           style: TextStyle(
//             fontSize: 23,
//             letterSpacing: 2,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Image.asset(
//                 "img/r2.png",
//                 height: 240.0,
//                 width: 240.0,
//               ),
//               const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                   "Login to your account",
//                   style: TextStyle(
//                       color: Colors.cyan,
//                       fontSize: 17,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     CustomTextField(
//                       controller: _emailTextEditingController,
//                       data: Icons.email,
//                       hintText: "Email",
//                       isObsecure: false,
//                     ),
//                     CustomTextField(
//                       controller: _passwordTextEditingController,
//                       data: Icons.lock,
//                       hintText: "Password",
//                       isObsecure: true,
//                     ),
//                   ],
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   _emailTextEditingController.text.isNotEmpty &&
//                           _passwordTextEditingController.text.isNotEmpty
//                       ? loginUser()
//                       : showDialog(
//                           context: context,
//                           builder: (c) {
//                             return const ErrorAlertDialog(
//                               message: "Please write Email and Password",
//                             );
//                           });
//                 },
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.cyan,
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(9.0),
//                   child: Text(
//                     "Login",
//                     style: TextStyle(color: Colors.white, fontSize: 21),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 30.0,
//               ),
//               // Container(
//               //   height: 4.0,
//               //   width: _screenWidth * 0.8,
//               //   color: Colors.cyan,
//               // ),
//               const SizedBox(
//                 height: 15.0,
//               ),
//               TextButton.icon(
//                 onPressed: () {
//                   Route route =
//                       MaterialPageRoute(builder: (c) => RegisterTechnisian());
//                   Navigator.push(context, route);
//                 },
//                 icon: const Icon(Icons.account_circle_rounded,
//                     color: Colors.lightBlue),
//                 label: const Text("No Account? Register",
//                     style: TextStyle(
//                         color: Colors.cyan, fontWeight: FontWeight.bold)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   late User firebaseUser;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   void loginUser() async {
//     showDialog(
//         context: context,
//         builder: (c) {
//           return const LoadingAlertDialog(
//             message: "Authenticating, Please wait...",
//           );
//         });
//     await _auth
//         .signInWithEmailAndPassword(
//       email: _emailTextEditingController.text.trim(),
//       password: _passwordTextEditingController.text.trim(),
//     )
//         .then((auth) {
//       firebaseUser = auth.user!;
//     }).catchError((error) {
//       Navigator.pop(context);
//       showDialog(
//           context: context,
//           builder: (c) {
//             return ErrorAlertDialog(
//               message: error.message.toString(),
//             );
//           });
//     });
//     readData(firebaseUser).then((s) {
//       technicianApp.firestore!
//           .collection("technician")
//           .doc(firebaseUser.uid)
//           .get()
//           .then((snapshot) async {
//         if (snapshot.data()!['role'] == "technician") {
//           //Save Data Locally
//           Navigator.pop(context);
//           Route route = MaterialPageRoute(builder: (c) => UploadPage());
//           Navigator.pushReplacement(context, route);
//         } else {
//           Navigator.pop(context);
//           showDialog(
//               context: context,
//               builder: (c) {
//                 return const ErrorAlertDialog(
//                   message: "Something bad Happend",
//                 );
//               });
//         }
//       });
//     });
//   }

//   Future readData(User currentUser) async {
//     await FirebaseFirestore.instance
//         .collection("technician")
//         .doc(currentUser.uid)
//         .get()
//         .then((snapshot) async {
//       //Save Data Locally
//       await technicianApp.sharedPreferences
//           ?.setString(technicianApp.userUID, firebaseUser.uid);

//       await technicianApp.sharedPreferences?.setString(
//           technicianApp.StationDesciption, snapshot.data()?['description']);

//       await technicianApp.sharedPreferences?.setString(
//           technicianApp.StationuserEmail, snapshot.data()?['email']);

//       await technicianApp.sharedPreferences
//           ?.setString(technicianApp.StationuserName, snapshot.data()?['name']);

//       await technicianApp.sharedPreferences
//           ?.setString(technicianApp.StationUrl, snapshot.data()?['url']);
//     });
//   }
// }
