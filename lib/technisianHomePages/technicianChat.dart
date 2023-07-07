import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:technicianApp/config/config.dart';

class technicianChat extends StatefulWidget {
  // String technicianAppId;
  // String technicianAppName;
  // technicianChat(
  //     {Key? key,
  //     required this.technicianAppId,
  //     required this.technicianAppName});

  @override
  _technicianChat createState() => _technicianChat();
}

class _technicianChat extends State<technicianChat> {
  TextEditingController msg = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final User? user = technicianApp.auth?.currentUser;
    final uid = user!.uid;
    // setState(() {
    //   widget.technicianAppId;
    //   widget.technicianAppName;
    // });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: Text(widget.technicianAppName),
      //   centerTitle: true,
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 520,
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              reverse: true,
              child: displayingMessage(),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black, width: 0.4)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msg,
                    decoration:
                        const InputDecoration(hintText: "Enter Message"),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // if (msg.text.isNotEmpty) {
                    //   technicianApp.firestore!
                    //       .collection("chatsRoom")
                    //       .doc("${widget.technicianAppId}_$uid")
                    //       .collection("chats")
                    //       .add(
                    //     {
                    //       "msg": msg.text.trim(),
                    //       "user": uid,
                    //       "email": technicianApp.userEmail.toString(),
                    //       "time": DateTime.now(),
                    //       "name": technicianApp.userName,
                    //       "technicianAppName": widget.technicianAppName,
                    //       "technicianAppId": widget.technicianAppId,
                    //     },
                    //   );
                    // }
                    setState(() {
                      msg.clear();
                    });
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class displayingMessage extends StatefulWidget {
  // String stationId;
  // String userId;
  // String stationName;

  // displayingMessage(
  //     {Key? key,
  //     required this.stationId,
  //     required this.stationName,
  //     required this.userId});
  @override
  _displayingMessage createState() => _displayingMessage();
}

class _displayingMessage extends State<displayingMessage> {
  @override
  Widget build(BuildContext context) {
    final User? user = technicianApp.auth?.currentUser;
    final uid = user!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: technicianApp.firestore!
          .collection("users")
          .doc(uid)
          .collection("chatRoom")
          .orderBy("time", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        } else {
          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            primary: true,
            physics: const ScrollPhysics(),
            itemBuilder: (context, i) {
              QueryDocumentSnapshot x = snapshot.data!.docs[i];
              if (x['user'] == uid) {
                print("This is User ${x['name']}");
                return ListTile(
                      title: Column(
                    crossAxisAlignment: technicianApp.userName == x['name']
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        color: technicianApp.userName == x['name']
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.amber.withOpacity(0.1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              x['msg'],
                            ),
                            Text(
                              x['name'],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Text("");
            },
          );
        }
      },
    );
  }
}
