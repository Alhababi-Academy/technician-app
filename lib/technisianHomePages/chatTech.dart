import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:technicianApp/Widgets/loadingWidget.dart';
import 'package:technicianApp/technisianHomePages/chatchat.dart';

class chatTech extends StatefulWidget {
  chatTech({Key? key}) : super(key: key);

  @override
  _chatTech createState() => _chatTech();
}

class _chatTech extends State<chatTech> {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  CollectionReference chats = FirebaseFirestore.instance.collection('chats');

  var chatDocId;
  var _textController = new TextEditingController();
  var keyss;
  var values;
  var key;
  var gettingUserID;
  var currentChatID;

  @override
  void initState() {
    super.initState();
    checkUser();
    print("This is the current ID $currentUserId");
  }

  void checkUser() async {
    await chats.get().then(
      (QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          var gettingData = querySnapshot.docs;
          for (var element in gettingData) {
            print(element['users']['UserID']);
            gettingUserID = element['users']['TechnisianID'];
            setState(() {
              gettingUserID = element['users']['TechnisianID'];
            });
          }
        } else {
          print("It's Empty");
        }
      },
    ).catchError((erorr) {
      print("Error Happend");
    });
  }

  void sendMessage(String msg) {
    if (msg == '') return;
    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': currentUserId,
      // 'friendName': friendName,
      'msg': msg
    }).then((value) {
      _textController.text = '';
    });
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
    // return Container(
    //   child: Text(gettingUserID.toString()),
    // );
    return CustomScrollView(
      slivers: [
        StreamBuilder(
          stream:
              chats.where("technisianID", isEqualTo: currentUserId).snapshots(),
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
                      currentChatID = snapshot.data!.docs[index].id;

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
                                // SizedBox(
                                //   height: 65.0,
                                //   width: 65.0,
                                //   child: CircleAvatar(
                                //     backgroundImage: NetworkImage(snapshot.data!
                                //             .docs[index]['thumbnailUrl'] ??
                                //         ''),
                                //   ),
                                // ),
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
                                              FontAwesome5.user_circle,
                                              color: Colors.blue,
                                              size: 40,
                                            ),
                                            const SizedBox(
                                              width: 25,
                                            ),
                                            Expanded(
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    ['userName'],
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
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: IconButton(
                                      onPressed: () {
                                        currentChatID =
                                            snapshot.data!.docs[index].id;
                                        Route route = MaterialPageRoute(
                                          builder: (c) => chatchat(
                                            currentChatID: currentChatID,
                                            friendName: snapshot
                                                .data!.docs[index]['userName'],
                                          ),
                                        );
                                        Navigator.push(context, route);
                                      },
                                      icon: const Icon(
                                        Icons.message,
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
    );
  }
}
