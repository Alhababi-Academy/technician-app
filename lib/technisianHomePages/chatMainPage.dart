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
import 'package:technicianApp/technisianHomePages/technicianHomePage.dart';

class chatMainPage extends StatefulWidget {
  @override
  _chatMainPage createState() => _chatMainPage();
}

class _chatMainPage extends State<chatMainPage> {
  // User? user;
  // String? currentUser;
  Color color1 = const Color.fromARGB(128, 43, 16, 215);
  Color color2 = const Color.fromARGB(96, 1, 26, 134);

  @override
  void initState() {
    final User? user = technicianApp.auth?.currentUser;
    final uid = user!.uid;
    technicianApp.firestore!
        .collection("chatRoom")
        .doc(uid)
        .collection("chatRoom")
        .doc()
        .get()
        .then((result) {
      var le = result.id.length;
      print("This is LE $le");
    });
    super.initState();
  }

  Future gettingData() async {}

  @override
  Widget build(BuildContext context) {
    final User? user = technicianApp.auth?.currentUser;
    final uid = user!.uid;
    var le;
    return Scaffold(
      bottomNavigationBar: Material(
        color: const Color.fromARGB(255, 22, 81, 255),
        // child: InkWell(
        //   onTap: () => takeImage(context),
        //   child: const SizedBox(
        //     height: kToolbarHeight,
        //     width: double.infinity,
        //     child: Center(
        //       child: Text(
        //         'Add Service',
        //         style:
        //             TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        //       ),
        //     ),
        //   ),
        // ),
      ),
      body: CustomScrollView(
        slivers: [
          
           StreamBuilder(
            stream: technicianApp.firestore!
                .collection("chatRoom")
                .doc("BrIZ6x32FkSsNjvcLxK9GXF4qCJ3")
                .collection("allChats")
                .where("technicianAppId", isEqualTo: uid)
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
                                  // SizedBox(
                                  //   height: 65.0,
                                  //   width: 65.0,
                                  //   child: CircleAvatar(
                                  //     backgroundImage: NetworkImage(
                                  //         snapshot.data!.docs[index]['url'] ??
                                  //             ''),
                                  //   ),
                                  // ),
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
                                              Text(
                                                snapshot.data!.docs[index]
                                                    ['name'],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15.0),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => {gettingData()},
                                    icon: Icon(Icons.chat),
                                    color: Colors.blueAccent,
                                    iconSize: 35,
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
}
