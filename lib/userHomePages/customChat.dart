import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:image_picker/image_picker.dart';
import 'package:technicianApp/DialogBox/loadingDialog.dart';
import 'package:technicianApp/config/config.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:technicianApp/userHomePages/allOrders.dart';

var chatDocId;

class customChat extends StatefulWidget {
  final technisianId;
  final TechnisianName;

  customChat({Key? key, this.technisianId, this.TechnisianName})
      : super(key: key);

  @override
  _customChat createState() => _customChat(technisianId, TechnisianName);
}

class _customChat extends State<customChat> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final friendUid;
  final friendName;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  var userName;
  XFile? xfile;
  late File imageFile;
  String? imageUrl;
  final ImagePicker _picker = ImagePicker();
  var _textController = new TextEditingController();

  _customChat(this.friendUid, this.friendName);
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    await chats
        .where('users',
            isEqualTo: {"TechnisianID": friendUid, "UserID": currentUserId})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            if (querySnapshot.docs.isNotEmpty) {
              setState(() {
                chatDocId = querySnapshot.docs.single.id;
              });

              print(chatDocId);
            } else {
              await chats.add({
                'users': {"TechnisianID": friendUid, "UserID": currentUserId},
                "technisianID": friendUid,
                "userName": technicianApp.sharedPreferences!
                    .getString(technicianApp.userName),
              }).then((value) => {chatDocId = value});
            }
          },
        )
        .catchError((error) {});
  }

  // void gettingUserData() async {
  //   technicianApp.firestore!
  //       .collection("users")
  //       .doc(currentUserId)
  //       .get()
  //       .then((result) {
  //     setState(() {
  //       userName = result.data()!['name'];
  //     });
  //     print("This is the name${userName}");
  //   });
  // }

  void sendMessage(String msg) {
    if (msg == '') return;
    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': currentUserId,
      'friendName': friendName,
      'msg': msg,
      'sentBy':
          technicianApp.sharedPreferences!.getString(technicianApp.userName),
    }).then((value) {
      _textController.text = '';
    });
  }

  void getImage(String imagePath) {
    if (imagePath == '') return;
  }

  bool isSender(String friend) {
    return friend == currentUserId;
  }

  Alignment getAlignment(friend) {
    if (friend == currentUserId) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chats
          .doc(chatDocId)
          .collection('messages')
          .orderBy('createdOn', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          var data;
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(friendName),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                child: const Text(""),
              ),
              previousPageTitle: "Back",
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      reverse: true,
                      children: snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          data = document.data()!;
                          print(document.toString());
                          print(data['msg']);
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ChatBubble(
                              clipper: ChatBubbleClipper6(
                                nipSize: 0,
                                radius: 0,
                                type: isSender(data['uid'].toString())
                                    ? BubbleType.sendBubble
                                    : BubbleType.receiverBubble,
                              ),
                              alignment: getAlignment(data['uid'].toString()),
                              margin: const EdgeInsets.only(top: 20),
                              backGroundColor: isSender(data['uid'].toString())
                                  ? const Color(0xFF08C187)
                                  : const Color(0xffE7E7ED),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        DefaultTextStyle(
                                          style: TextStyle(
                                              color: isSender(
                                            data['uid'].toString(),
                                          )
                                                  ? Colors.white
                                                  : Colors.black),
                                          // child: Text(
                                          //   data['msg'],
                                          //   maxLines: 100,
                                          //   overflow: TextOverflow.ellipsis,
                                          // ),
                                          child: Column(
                                            children: [
                                              data['msg'].length < 20
                                                  ? Text(
                                                      data['msg'],
                                                      maxLines: 100,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )
                                                  : Image.network(
                                                      data['msg'],
                                                      width: 200,
                                                      height: 200,
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        DefaultTextStyle(
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: isSender(
                                                      data['uid'].toString())
                                                  ? Colors.white
                                                  : Colors.black),
                                          child: Text(
                                            data['createdOn'] == null
                                                ? DateTime.now().toString()
                                                : data['createdOn']
                                                    .toDate()
                                                    .toString(),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: CupertinoTextField(
                            controller: _textController,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        child: const Icon(Icons.image),
                        onPressed: () =>
                            pickImage(context, currentUserId, friendName),
                      ),
                      CupertinoButton(
                        child: const Icon(Icons.send_sharp),
                        onPressed: () => sendMessage(_textController.text),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  pickImage(BuildContext context, friendName, currentUserId) async {
    return await showDialog(
      context: context,
      builder: (con) {
        return SimpleDialog(
          title: const Text(
            "Send Image",
            textAlign: TextAlign.center,
          ),
          alignment: Alignment.center,
          titlePadding: const EdgeInsets.all(5),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 15,
                left: 15,
              ),
              child: ElevatedButton.icon(
                  onPressed: () {
                    cameraPicking(currentUserId, friendName);
                  },
                  style: ElevatedButton.styleFrom(),
                  icon: const Icon(Icons.camera),
                  label: const Text("Camera")),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 15,
                left: 15,
              ),
              child: ElevatedButton.icon(
                  onPressed: () {
                    galleryPicking(currentUserId, friendName);
                  },
                  style: ElevatedButton.styleFrom(),
                  icon: const Icon(Icons.image),
                  label: const Text("Gallary")),
            )
          ],
        );
      },
    );
  }

  Future galleryPicking(currentUserId, friendName) async {
    var pickingImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickingImage != null) {
      imageFile = File(pickingImage.path);
      savingImageToStorage(imageFile);
    }
  }

  Future cameraPicking(currentUserId, friendName) async {
    var pickingImage = await _picker.pickImage(source: ImageSource.camera);
    if (pickingImage != null) {
      imageFile = File(pickingImage.path);
      savingImageToStorage(imageFile);
    }
  }

  Future savingImageToStorage(File imageFile) async {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (c) => const LoadingAlertDialog(
        message: "Loading",
      ),
    );
    String imageName = DateTime.now().microsecondsSinceEpoch.toString();
    fStorage.Reference reference =
        fStorage.FirebaseStorage.instance.ref("chatImages").child(imageName);
    fStorage.UploadTask uploadTask = reference.putFile(imageFile);
    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((url) {
      imageUrl = url;
      savingImageToDatabase(imageUrl, currentUserId, friendName);
      Navigator.pop(context);
    });
  }
}

Future savingImageToDatabase(
    String? imageUrl, String? currentUserId, friendName) async {
  technicianApp.firestore!
      .collection("chats")
      .doc(chatDocId)
      .collection("messages")
      .add(
    {
      'createdOn': FieldValue.serverTimestamp(),
      'uid': currentUserId,
      'friendName': friendName,
      'msg': imageUrl,
      'sentBy':
          technicianApp.sharedPreferences!.getString(technicianApp.userName),
    },
  );
}
