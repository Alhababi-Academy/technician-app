// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:technicianApp/config/config.dart';
// import 'package:technicianApp/DialogBox/errorDialog.dart';
// import 'package:technicianApp/DialogBox/loadingDialog.dart';
// import 'package:technicianApp/Widgets/customTextField.dart';
// import 'package:firebase_storage/firebase_storage.dart' as fStorage;
// import 'package:technicianApp/stationHomePages/stationHomePage.dart';
// import 'package:technicianApp/technicianAuth/loginStation.dart';

// class RegisterTechnisian extends StatefulWidget {
//   @override
//   _RegisterTechnisian createState() => _RegisterTechnisian();
// }

// RegistrarRole role = RegistrarRole.user;

// enum RegistrarRole { user, technisian }

// class _RegisterTechnisian extends State<RegisterTechnisian> {
//   final TextEditingController _stationName = TextEditingController();
//   final TextEditingController _stationEmail = TextEditingController();
//   final TextEditingController _stationDescription = TextEditingController();
//   final TextEditingController _genderEdtiginController =
//       TextEditingController();
//   final TextEditingController _passwordTextEditingController =
//       TextEditingController();
//   final TextEditingController _cPasswordTextEditingController =
//       TextEditingController();
//   final TextEditingController _locationController = TextEditingController();

//   final String role = 'technician';
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   String userImageUrl = "";
//   XFile? imageXFile;
//   final ImagePicker _picker = ImagePicker();

//   Position? position;
//   List<Placemark>? placemarks;

//   Future<void> _getImage() async {
//     imageXFile = await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       imageXFile;
//     });
//   }

//   getCurrentLocation() async {
//     LocationPermission permission;
//     permission = await Geolocator.requestPermission();
//     Position newPosition = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     position = newPosition;
//     placemarks = await placemarkFromCoordinates(
//       position!.latitude,
//       position!.longitude,
//     );
//     Placemark pMark = placemarks![0];
//     String complateAddress =
//         '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.postalCode}, ${pMark.country}';
//     _locationController.text = complateAddress;
//   }

//   @override
//   Widget build(BuildContext context) {
//     double _screenWidth = MediaQuery.of(context).size.width,
//         _screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Technician Register",
//           style: TextStyle(
//             fontSize: 23,
//             letterSpacing: 2,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             const SizedBox(
//               height: 25.0,
//             ),
//             InkWell(
//               onTap: () {
//                 _getImage();
//               },
//               child: CircleAvatar(
//                 radius: _screenWidth * 0.15,
//                 backgroundColor: Colors.white,
//                 backgroundImage: imageXFile == null
//                     ? null
//                     : FileImage(File(imageXFile!.path)),
//                 child: imageXFile == null
//                     ? Icon(
//                         Icons.add_photo_alternate,
//                         size: MediaQuery.of(context).size.width * 0.20,
//                         color: Colors.grey,
//                       )
//                     : null,
//               ),
//             ),
//             const SizedBox(
//               height: 8.0,
//             ),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   CustomTextField(
//                     controller: _stationName,
//                     data: Icons.fire_extinguisher,
//                     hintText: "Name",
//                     isObsecure: false,
//                   ),
//                   CustomTextField(
//                     controller: _stationEmail,
//                     data: Icons.email,
//                     hintText: "Email",
//                     isObsecure: false,
//                   ),
//                   CustomTextField(
//                     controller: _stationDescription,
//                     data: Icons.description,
//                     hintText: "Description",
//                     isObsecure: false,
//                   ),

//                   CustomTextField(
//                     controller: _passwordTextEditingController,
//                     data: Icons.lock,
//                     hintText: "Password",
//                     isObsecure: true,
//                   ),
//                   CustomTextField(
//                     controller: _cPasswordTextEditingController,
//                     data: Icons.lock,
//                     hintText: "Confirm Password",
//                     isObsecure: true,
//                   ),
//                   // CustomTextField(
//                   //   controller: _locationController,
//                   //   data: Icons.map_outlined,
//                   //   hintText: "Station Address",
//                   //   isObsecure: false,
//                   //   isEnabled: false,
//                   // ),
//                   // Container(
//                   //   width: 400,
//                   //   height: 40,
//                   //   alignment: Alignment.center,
//                   //   child: ElevatedButton.icon(
//                   //     onPressed: () {
//                   //       getCurrentLocation();
//                   //     },
//                   //     label: const Text(
//                   //       "Get my Current Location",
//                   //       style: TextStyle(color: Colors.white),
//                   //     ),
//                   //     style: ElevatedButton.styleFrom(
//                   //       primary: Colors.lightBlue,
//                   //       shape: RoundedRectangleBorder(
//                   //         borderRadius: BorderRadius.circular(30),
//                   //       ),
//                   //     ),
//                   //     icon: const Icon(
//                   //       Icons.location_on,
//                   //       color: Colors.white,
//                   //     ),
//                   //   ),
//                   // ),
//                   const SizedBox(
//                     height: 20,
//                   )
//                 ],
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 formValidation();
//               },
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.blue,
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.all(12.0),
//                 child: Text(
//                   "Sign up",
//                   style: TextStyle(color: Colors.white, fontSize: 20),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 30.0,
//             ),
//             TextButton.icon(
//               onPressed: () {
//                 Route route = MaterialPageRoute(builder: (c) => stationLogin());
//                 Navigator.push(context, route);
//               },
//               icon: const Icon(Icons.account_circle_rounded,
//                   color: Colors.lightBlue),
//               label: const Text("Technician Login",
//                   style: TextStyle(
//                       color: Colors.cyan, fontWeight: FontWeight.bold)),
//             ),
//             const SizedBox(
//               height: 15.0,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> formValidation() async {
//     if (imageXFile == null) {
//       showDialog(
//         context: context,
//         builder: (c) {
//           return const ErrorAlertDialog(message: "Please Select an Image");
//         },
//       );
//     } else {
//       displayDialog(String msg) {
//         showDialog(
//             context: context,
//             builder: (c) {
//               return ErrorAlertDialog(
//                 message: msg,
//               );
//             });
//       }

//       _passwordTextEditingController.text ==
//               _cPasswordTextEditingController.text
//           ? _stationEmail.text.isNotEmpty &&
//                   _passwordTextEditingController.text.isNotEmpty &&
//                   _cPasswordTextEditingController.text.isNotEmpty &&
//                   _stationName.text.isNotEmpty
//               ? uploadToStorage()
//               : displayDialog("Fill up The Technician Station Form")
//           : displayDialog("Password do not match.");
//     }
//   }

//   uploadToStorage() async {
//     showDialog(
//         context: context,
//         builder: (c) {
//           return const LoadingAlertDialog(
//             message: "Registering, Please wait....",
//           );
//         });

//     String imageFileName = DateTime.now().microsecondsSinceEpoch.toString();
//     fStorage.Reference reference = fStorage.FirebaseStorage.instance
//         .ref()
//         .child("stationsImages")
//         .child(imageFileName);
//     fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
//     fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
//     await taskSnapshot.ref.getDownloadURL().then((url) {
//       userImageUrl = url;
//     });
//     _registerUser();
//   }

//   late User firebaseUser;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   void _registerUser() async {
//     await _auth
//         .createUserWithEmailAndPassword(
//       email: _stationEmail.text.trim(),
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

//     saveUserInfoToFireStor(firebaseUser).then((value) {
//       Navigator.pop(context);
//       Route route = MaterialPageRoute(builder: (c) => stationLogin());
//       Navigator.pushReplacement(context, route);
//     });
//   }

//   Future saveUserInfoToFireStor(User fUser) async {
//     FirebaseFirestore.instance.collection("technician").doc(fUser.uid).set({
//       "name": _stationName.text.trim(),
//       "uid": fUser.uid,
//       "email": fUser.email,
//       "role": role.trim(),
//       "description": _stationDescription.text.trim(),
//       "url": userImageUrl,
//     });
//     //Save Data Locally
//     await technicianApp.sharedPreferences
//         ?.setString(technicianApp.StationuserUID, fUser.uid);

//     await technicianApp.sharedPreferences
//         ?.setString(technicianApp.StationuserName, _stationName.text.trim());

//     await technicianApp.sharedPreferences
//         ?.setString(technicianApp.StationuserEmail, _stationEmail.text.trim());

//     await technicianApp.sharedPreferences?.setString(
//         technicianApp.StationDesciption, _stationDescription.text.trim());
//   }
// }
