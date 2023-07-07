import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:technicianApp/Authentication/login.dart';
import 'package:technicianApp/Models/item.dart';
import 'package:technicianApp/Widgets/loadingWidget.dart';
import 'package:technicianApp/config/config.dart';
import 'package:technicianApp/technisianHomePages/editService.dart';
import 'package:technicianApp/technisianHomePages/technicianHomePage.dart';

class servicesUploadPage extends StatefulWidget {
  @override
  _servicesUploadPage createState() => _servicesUploadPage();
}

class _servicesUploadPage extends State<servicesUploadPage> {
  // User? user;
  // String? currentUser;
  Color color1 = const Color.fromARGB(128, 43, 16, 215);
  Color color2 = const Color.fromARGB(96, 1, 26, 134);
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _serviceName = TextEditingController();
  final TextEditingController _descriptionTextEditingController =
      TextEditingController();
  final TextEditingController _priceTextEditingController =
      TextEditingController();
  // @override
  // void initState() {
  //   user = technicianApp.auth!.currentUser;
  //   currentUser = user!.uid;
  //   super.initState();
  // }

  String productId = DateTime.now().microsecondsSinceEpoch.toString();
  bool uploading = false;
  XFile? imageXFile;
  final _picker = ImagePicker();
  String uploadImageUrl = "";

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   currentUser;
    // });
    return imageXFile == null
        ? getAdminHomeScreenBody()
        : displayAdminUploadFormScreen();
  }

  getAdminHomeScreenBody() {
    final User? user = technicianApp.auth?.currentUser;
    final uid = user!.uid;
    return Scaffold(
      bottomNavigationBar: Material(
        color: Colors.blue,
        child: InkWell(
          onTap: () => takeImage(context),
          child: const SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
            child: Center(
              child: Text(
                'Add Service',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          StreamBuilder(
            stream: technicianApp.firestore!
                .collection("services")
                .doc(uid)
                .collection("AllServicesPerUser")
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        var currentId = snapshot.data!.docs[index].id;
                        // ItemModel model = ItemModel.fromJson(
                        //     dataSnapshot.data?.docs[index].data()
                        //         as Map<String, dynamic>);
                        return InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0XFFE3E3E3)),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  SizedBox(
                                    height: 65.0,
                                    width: 65.0,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(snapshot
                                              .data!
                                              .docs[index]['thumbnailUrl'] ??
                                          ''),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 85.0,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              const Icon(
                                                FontAwesome5.car_crash,
                                                color: Colors.blue,
                                                size: 25,
                                              ),
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      ['serviceName'],
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              const Icon(
                                                FontAwesome5.info_circle,
                                                color: Colors.blue,
                                                size: 25,
                                              ),
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      ['longDescription'],
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow: TextOverflow.fade,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              const Icon(
                                                Icons.price_change,
                                                color: Colors.blue,
                                                size: 27,
                                              ),
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              Text(
                                                snapshot
                                                    .data!.docs[index]['price']
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              const Icon(
                                                Icons.payments,
                                                color: Colors.blue,
                                                size: 27,
                                              ),
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              Text(
                                                snapshot.data!.docs[index]
                                                    ['PaymentMethod'],
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: IconButton(
                                        onPressed: () {
                                          editingData(currentId);
                                        },
                                        icon: const Icon(
                                          FontAwesome.edit,
                                          size: 30,
                                          color: Colors.blue,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
            },
          ),
        ],
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            contentPadding: EdgeInsets.zero,
            title: SimpleDialogOption(
              padding: EdgeInsets.all(0),
              child: IconButton(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 5, top: 5),
                iconSize: 40,
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            titlePadding: EdgeInsets.all(5),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.zero,
                onPressed: _getImageFromGallary,
                child: const Icon(
                  Icons.image,
                  color: Colors.blueGrey,
                  size: 60,
                ),
              ),
              SimpleDialogOption(
                onPressed: capturePhotoWithCamera,
                child: const Icon(
                  Icons.camera,
                  color: Colors.blueGrey,
                  size: 60,
                ),
              ),
            ],
          );
        });
  }

  _getImageFromGallary() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      imageXFile;
    });
  }

  List<String> PaymentMehod = ['Gcash', 'Maya', 'COD'];
  String? value;

  Widget displayAdminUploadFormScreen() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            uploading ? circularProgress() : const Text(""),
            const Text(
              "Add Technician Service",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 22),
            ),
            SizedBox(
              height: 230.0,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(File(imageXFile!.path)),
                            fit: BoxFit.fill)),
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 12.0)),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.blue,
              ),
              title: SizedBox(
                width: 250.0,
                child: TextField(
                  style: const TextStyle(color: Colors.indigo),
                  controller: _serviceName,
                  decoration: const InputDecoration(
                    hintText: "Service Name",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: const Icon(
                Icons.payments,
                color: Colors.blue,
              ),
              title: SizedBox(
                width: 250.0,
                child: DropdownButton<String>(
                  value: value,
                  hint: const Text("Please select Payment method"),
                  items: PaymentMehod.map(buildMenuItem).toList(),
                  onChanged: (value) => setState(() => this.value = value),
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: const Icon(
                Icons.description,
                color: Colors.blue,
              ),
              title: SizedBox(
                width: 250.0,
                child: TextField(
                  style: const TextStyle(color: Colors.indigo),
                  controller: _descriptionTextEditingController,
                  decoration: const InputDecoration(
                    hintText: "Please Describe your service",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: const Icon(
                Icons.price_change,
                color: Colors.blue,
              ),
              title: SizedBox(
                width: 250.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.indigo),
                  controller: _priceTextEditingController,
                  decoration: const InputDecoration(
                    hintText: "Price Estimate",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                onPressed:
                    uploading ? null : () => uploadImageAndSaveItemInfo(),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                label: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Add Service",
                    style: TextStyle(fontSize: 23.0, color: Colors.white),
                  ),
                ),
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // For the drop down Items
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      );

  clearFormInfo() {
    Route route = MaterialPageRoute(builder: (c) => technicianHomePage());
    Navigator.pushReplacement(context, route);
    setState(() {
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _serviceName.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });

    String imageDownloadUrl = await uploadingItemImage(imageXFile);

    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadingItemImage(mFileImage) async {
    String downloadUrl;
    String imageName = DateTime.now().microsecondsSinceEpoch.toString();
    fStorage.Reference reference =
        fStorage.FirebaseStorage.instance.ref().child("Items").child(imageName);
    fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((url) {
      uploadImageUrl = url;
    });
    return uploadImageUrl;
  }

  saveItemInfo(String downloadUrl) {
    final User? user = technicianApp.auth?.currentUser;
    final uid = user!.uid;
    final itemsRef = FirebaseFirestore.instance
        .collection("services")
        .doc(uid)
        .collection("AllServicesPerUser")
        .add({
      "serviceName": _serviceName.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "price": int.parse(_priceTextEditingController.text),
      "publishedDate": DateTime.now(),
      "thumbnailUrl": downloadUrl,
      "userUid": uid,
      "PaymentMethod": value,
      "serviceUid": productId.toString(),
    });

    setState(() {
      uploading = false;
      productId = DateTime.now().microsecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _serviceName.clear();
      _priceTextEditingController.clear();
    });

    Route route = MaterialPageRoute(builder: (c) => technicianHomePage());
    Navigator.pushReplacement(context, route);
  }

  Future editingData(String currentId) async {
    final User? user = technicianApp.auth?.currentUser;
    final uid = user!.uid;
    // technicianApp.firestore!
    //     .collection("services")
    //     .doc(uid)
    //     .collection("AllServicesPerUser")
    //     .doc(currentId)
    //     .update({

    //     });
    Route route = MaterialPageRoute(
        builder: (context) => editService(
              serviceId: currentId,
            ));
    Navigator.push(context, route);
  }
}
