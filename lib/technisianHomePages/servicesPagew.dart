import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:technicianApp/Authentication/login.dart';
import 'package:technicianApp/Models/item.dart';
import 'package:technicianApp/Widgets/loadingWidget.dart';
import 'package:technicianApp/config/config.dart';

class UploadPagew extends StatefulWidget {
  @override
  _UploadPagew createState() => _UploadPagew();
}

class _UploadPagew extends State<UploadPagew> {
  User? user;
  String? currentUser;
  Color color1 = const Color.fromARGB(128, 43, 16, 215);
  Color color2 = const Color.fromARGB(96, 1, 26, 134);
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _serviceName = TextEditingController();
  final TextEditingController _descriptionTextEditingController =
      TextEditingController();
  final TextEditingController _priceTextEditingController =
      TextEditingController();
  @override
  void initState() {
    user = technicianApp.auth!.currentUser;
    currentUser = user!.uid;
    super.initState();
  }

  String productId = DateTime.now().microsecondsSinceEpoch.toString();
  bool uploading = false;
  XFile? imageXFile;
  final _picker = ImagePicker();
  String uploadImageUrl = "";

  @override
  Widget build(BuildContext context) {
    setState(() {
      currentUser;
    });
    return imageXFile == null
        ? getAdminHomeScreenBody()
        : displayAdminUploadFormScreen();
  }

  getAdminHomeScreenBody() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color1, color2],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          technicianApp.sharedPreferences
                  ?.getString(technicianApp.TechnicianName) ??
              '',
          style: const TextStyle(fontSize: 25, letterSpacing: 2),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => Login());
                Navigator.pushReplacement(context, route);
              },
              icon: const Icon(
                Icons.logout,
                size: 25,
              ))
        ],
      ),
      bottomNavigationBar: Material(
        color: const Color.fromARGB(255, 22, 81, 255),
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
          StreamBuilder<DocumentSnapshot>(
            stream: technicianApp.firestore!
                .collection("services")
                .doc(user!.uid)
                .snapshots(),
            builder: (context, dataSnapshot) {
              return !dataSnapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        // ItemModel model = ItemModel.fromJson(
                        //     dataSnapshot.data?.docs[index].data()
                        //         as Map<String, dynamic>);
                        return InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.blueGrey),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  SizedBox(
                                    height: 65.0,
                                    width: 65.0,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(dataSnapshot
                                              .data![index]['thumbnailUrl'] ??
                                          ''),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 85.0,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Service Name: ${dataSnapshot.data![index]['thumbnailUrl']}",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Description: ${dataSnapshot.data![index]['thumbnailUrl']}",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Price: ${dataSnapshot.data![index]['thumbnailUrl']}₱",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Row(
                                          //   mainAxisSize: MainAxisSize.max,
                                          //   children: [
                                          //     Expanded(
                                          //       child: Text(
                                          //         ",
                                          //         style: const TextStyle(
                                          //             color: Colors.white, fontSize: 15.0),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // ElevatedButton(
                                  //   child: const Text("Edit"),
                                  //   onPressed: () {},
                                  // ),
                                  // const SizedBox(
                                  //   width: 20,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: dataSnapshot.data!.id.length,
                    );
            },
          ),
        ],
      ),
    );
  }

  // Widget sourceInfo(ItemModel model, BuildContext context,
  //     {required Color background, removeCarFunction}) {

  // }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: const Text(
              "Add Image",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                child: const Text("Select From Gallery with Gallery",
                    style: TextStyle(color: Colors.blue)),
                onPressed: _getImageFromGallary,
              ),
              SimpleDialogOption(
                child: const Text("Take Picture with Camera",
                    style: TextStyle(color: Colors.blue)),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  Navigator.pop(context);
                },
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

  Widget displayAdminUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: clearFormInfo),
        title: const Text(
          "Adding New Service",
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : const Text(""),
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
                          fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: const Icon(
              Icons.wrap_text,
              color: Colors.blue,
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                style: const TextStyle(color: Colors.indigo),
                controller: _serviceName,
                decoration: const InputDecoration(
                  hintText: "Service Name",
                  hintStyle: TextStyle(color: Colors.indigo),
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
              Icons.description,
              color: Colors.blue,
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                style: const TextStyle(color: Colors.indigo),
                controller: _descriptionTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.indigo),
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
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.indigo),
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
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Add Service",
                  style: TextStyle(fontSize: 23.0, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  clearFormInfo() {
    Route route = MaterialPageRoute(builder: (c) => UploadPagew());
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
    final itemsRef = FirebaseFirestore.instance
        .collection("stations")
        .doc(currentUser)
        .collection("services");
    itemsRef.doc(productId).set({
      "serviceName": _serviceName.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "price": int.parse(_priceTextEditingController.text),
      "publishedDate": DateTime.now(),
      "thumbnailUrl": downloadUrl,
      "userUid": currentUser,
      "serviceUid": productId.toString(),
    });

    setState(() {
      uploading = false;
      productId = DateTime.now().microsecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _serviceName.clear();
      _priceTextEditingController.clear();
    });

    Route route = MaterialPageRoute(builder: (c) => UploadPagew());
    Navigator.pushReplacement(context, route);
  }
}
