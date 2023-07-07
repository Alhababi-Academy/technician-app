import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:technicianApp/DialogBox/errorDialog.dart';
import 'package:technicianApp/DialogBox/loadingDialog.dart';
import 'package:technicianApp/config/config.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:technicianApp/technisianHomePages/technicianHomePage.dart';
import 'package:technicianApp/userHomePages/homePage.dart';

class editProfile extends StatefulWidget {
  const editProfile({Key? key}) : super(key: key);

  @override
  _editProfile createState() => _editProfile();
}

class _editProfile extends State<editProfile> {
  User? user = technicianApp.auth!.currentUser;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController _userName = TextEditingController();
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  String _imageUrl = '';
  // int? servicePrice;

  @override
  void initState() {
    gettingData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Getting Data
  Future gettingData() async {
    String uid = user!.uid;

    var result =
        await technicianApp.firestore!.collection("users").doc(uid).get();

    if (result != null) {
      name.text = result.data()!['name'];
      email.text = result.data()!['email'];
      _userName.text = result.data()!['username'];
      _imageUrl = result.data()!['url'];
      setState(() {
        _imageUrl;
      });
    } else {
      print("Sorry There is no Data");
    }
  }

  Future _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            "Edit Profile",
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 33,
                letterSpacing: 1),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      _getImage();
                    },
                    // child: CircleAvatar(
                    //   radius: 70,
                    //   backgroundColor: Colors.white,
                    //   backgroundImage:
                    //       _imageUrl == null ? null : NetworkImage(_imageUrl),
                    //   child: _imageUrl == null
                    //       ? Icon(
                    //           Icons.add_photo_alternate,
                    //           size: MediaQuery.of(context).size.width * 0.20,
                    //           color: Colors.grey,
                    //         )
                    //       : null,
                    // ),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      backgroundImage: imageXFile == null
                          ? null
                          : FileImage(File(imageXFile!.path)),
                      child: imageXFile == null
                          ? Icon(
                              Icons.add_photo_alternate,
                              size: MediaQuery.of(context).size.width * 0.20,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: name,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            FontAwesome5.car_crash,
                            color: Colors.blue,
                            size: 25,
                          ),
                          labelText: "Name"),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: email,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            FontAwesome5.info_circle,
                            color: Colors.blue,
                            size: 25,
                          ),
                          labelText: "Email"),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       color: Colors.black12,
                  //       borderRadius: BorderRadius.circular(10)),
                  //   child: TextField(
                  //     controller: _userName,
                  //     decoration: const InputDecoration(
                  //         border: InputBorder.none,
                  //         prefixIcon: Icon(
                  //           Icons.person,
                  //           color: Colors.blue,
                  //           size: 25,
                  //         ),
                  //         labelText: "Username"),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () => name.text.isNotEmpty && email.text.isNotEmpty
                  ? uploadToStorage()
                  : showDialog(
                      context: context,
                      builder: (c) =>
                          const ErrorAlertDialog(message: "Can't be Empty")),
              style:
                  ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
              child: const Text(
                "Save Data",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return const LoadingAlertDialog(
            message: "Saving Data, Please Wait...",
          );
        });
    if (imageXFile != null) {
      String imageFileName = DateTime.now().microsecondsSinceEpoch.toString();
      fstorage.Reference reference = fstorage.FirebaseStorage.instance
          .ref()
          .child("usersImages")
          .child(imageFileName);
      fstorage.UploadTask uploadTask =
          reference.putFile(File(imageXFile!.path));
      fstorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      await taskSnapshot.ref.getDownloadURL().then((url) {
        _imageUrl = url;
      });
      updatingData();
    } else {
      updatingData();
    }
  }

  Future updatingData() async {
    User? user = technicianApp.auth!.currentUser;
    String uid = user!.uid;

    showDialog(
        context: context,
        builder: (c) => const LoadingAlertDialog(
              message: "Saving Data...",
            ));

    await technicianApp.firestore!.collection("users").doc(uid).update({
      "name": name.text.trim(),
      "email": email.text.trim(),
      "url": _imageUrl,
    }).then((value) {
      Navigator.pop(context);
      Route route = MaterialPageRoute(builder: (context) => homePage());
      Navigator.pushReplacement(context, route);
    });
  }
}
