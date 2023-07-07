import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:technicianApp/Authentication/login.dart';
import 'package:technicianApp/DialogBox/errorDialog.dart';
import 'package:technicianApp/DialogBox/loadingDialog.dart';
import 'package:technicianApp/config/config.dart';
import 'package:technicianApp/userHomePages/homePage.dart';
import '../Widgets/customTextField.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

RegistrarRole _role = RegistrarRole.user;

enum RegistrarRole { user, technician }

class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cPasswordTextEditingController =
      TextEditingController();
  final TextEditingController _currentLocation = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  final TextEditingController _userName = TextEditingController();

  String role = "user";

  String imageUrl = '';
  final ImagePicker _picker = ImagePicker();
  XFile? imageXFile;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Position? position;
  List<Placemark>? placemark;

  showingDialogChecking() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const LoadingAlertDialog(
              message: "Please Wait, Getting your location",
            )).then((value) {});
  }

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    } else {
      showingDialogChecking();
      Position newPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      position = newPosition;
      placemark = await placemarkFromCoordinates(
        position!.latitude,
        position!.longitude,
      );

      Placemark pMark = placemark![0];
      String complateAddress =
          '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.postalCode}, ${pMark.country}';
      _currentLocation.text = complateAddress;
      Navigator.pop(context);
      return _currentLocation.text;
    }
  }

// thisi s the function to get image
  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Material(
        child: Container(
          padding: EdgeInsets.all(7),
          color: Colors.blue.shade300,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // here where to pick image
                    InkWell(
                      onTap: () {
                        _getImage();
                      },
                      child: CircleAvatar(
                        radius: _screenWidth * 0.15,
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
                      height: 25.0,
                    ),
                    CustomTextField(
                      controller: _nameTextEditingController,
                      data: Icons.person,
                      hintText: "Name",
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: _emailTextEditingController,
                      data: Icons.email,
                      hintText: "Email",
                      isObsecure: false,
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ListTile(
                            title: const Text('User'),
                            leading: Radio(
                              value: RegistrarRole.user,
                              groupValue: _role,
                              onChanged: (RegistrarRole? value) {
                                setState(() {
                                  _role = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          child: ListTile(
                            title: const Text('Technician'),
                            leading: Radio(
                              value: RegistrarRole.technician,
                              groupValue: _role,
                              onChanged: (RegistrarRole? value) {
                                setState(() {
                                  _role = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    CustomTextField(
                      controller: _phoneNumber,
                      data: Icons.phone_android,
                      hintText: "Phone Number",
                      textType: TextInputType.number,
                      isEnabled: true,
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: _passwordTextEditingController,
                      data: Icons.lock,
                      hintText: "Password",
                      isObsecure: true,
                    ),
                    CustomTextField(
                      controller: _cPasswordTextEditingController,
                      data: Icons.lock,
                      hintText: "Confirm Password",
                      isObsecure: true,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                          onPressed: () => {_determinePosition()},
                          icon: const Icon(Icons.map_rounded),
                          label: const Text("Get Current Location")),
                    ),
                    CustomTextField(
                      controller: _currentLocation,
                      data: Icons.map_sharp,
                      hintText: "Current Location",
                      isObsecure: false,
                      isEnabled: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  uploadAndSaveImage();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Sign up",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => Login());
                  Navigator.push(context, route);
                },
                icon: const Icon(Icons.account_box, color: Colors.white),
                label: const Text("Login?",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> uploadAndSaveImage() async {
    _passwordTextEditingController.text == _cPasswordTextEditingController.text
        ? _emailTextEditingController.text.isNotEmpty &&
                _passwordTextEditingController.text.isNotEmpty &&
                _cPasswordTextEditingController.text.isNotEmpty &&
                _nameTextEditingController.text.isNotEmpty &&
                _currentLocation.text.isNotEmpty
            ? uploadToStorage()
            : displayDialog("Please fill up the registration form..")
        : displayDialog("Password do not match.");
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
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
        imageUrl = url;
      });
      _registerUser();
    } else {
      _registerUser();
    }
  }

  void _registerUser() async {
    await technicianApp.auth
        ?.createUserWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((auth) {
      technicianApp.user = auth.user!;
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
    saveUserInfo(technicianApp.user);
  }

  Future saveUserInfo(User? user) async {
    var currentTime = DateTime.now();
    await technicianApp.firestore!.collection("users").doc(user!.uid).set({
      "uid": user.uid.toString(),
      "name": _nameTextEditingController.text.trim(),
      "email": _emailTextEditingController.text.trim(),
      "role": _role.name,
      "location": _currentLocation.text.trim(),
      "lat": position!.latitude,
      "long": position!.longitude,
      "phoneNumber": int.parse(_phoneNumber.text.trim()),
      "RegistredTime": DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      "url": imageUrl.toString().trim(),
    });

    Navigator.pop(context);
    Route route = MaterialPageRoute(builder: (context) => Login());
    Navigator.pushReplacement(context, route);
  }
}
