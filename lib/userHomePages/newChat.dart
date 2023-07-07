import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:technicianApp/config/config.dart';
import 'package:technicianApp/userHomePages/allOrders.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  final technisianId;
  final TechnisianName;
  const ChatPage({super.key, this.technisianId, this.TechnisianName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  User? user = technicianApp.auth!.currentUser;
  var chatDocId;
  List<types.Message> _messages = [];

  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');

  @override
  void initState() {
    super.initState();
    _checkIfChatIsAvailable();
    _gettingMessages();
  }

  void _checkIfChatIsAvailable() async {
    String currentUser = user!.uid;
    var chats = technicianApp.firestore!.collection("chats");
    await chats
        .where('users', isEqualTo: {
          "TechnisianID": widget.technisianId,
          "UserID": currentUser
        })
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
                'users': {
                  "TechnisianID": widget.technisianId,
                  "UserID": currentUser
                },
                "technisianID": widget.technisianId,
                "userName": technicianApp.sharedPreferences!
                    .getString(technicianApp.userName),
              }).then((value) => {chatDocId = value});
            }
          },
        )
        .catchError((error) {});
  }

  _gettingMessages<List>() async {
    String currentUser = user!.uid;
    var chats = technicianApp.firestore!
        .collection("chats")
        .doc(chatDocId)
        .collection('messages')
        // .orderBy('createdOn', descending: true)
        .snapshots();

    await for (var messagesGetting in chats) {
      for (var messages in messagesGetting.docs) {
        print("This is the data ${messages.data()['msg']}");
        // _messages = messages.data().values.toList();
        List gee = messages.data()['msg'];

        // _messages = gee.toList(this);
        setState(() {
          _messages.addAll(messages.data()['msg']);
          // _messages = messages.data().values.toList();
        });
      }
    }

    //     .listen((event) {
    //   var messages = event.docs;
    //   for (var element in messages) {
    //     print("All messages for Reach $element");
    //   }
    //   print("All messages before $messages");
    //   setState(() {
    //     _messages = messages.cast<types.Message>().toList();
    //     print("All messages $_messages");
    //   });
    // });
    // return StreamBuilder(
    //   stream: chats
    //       .doc(chatDocId)
    //       .collection('messages')
    //       // .orderBy('createdOn', descending: true)
    //       .snapshots(),
    //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //     print("All mes ${snapshot.data!.docs}");
    //     return !snapshot.hasData
    //         ? const CircularProgressIndicator()
    //         : Text(
    //             snapshot.data!.docs.toString(),
    //           );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    _gettingMessages();
    return Scaffold(
      body: Chat(
        messages: _messages,
        onAttachmentPressed: _handleAtachmentPressed,
        onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        showUserAvatars: true,
        showUserNames: true,
        user: _user,
      ),
    );
  }

  void _addMessage(types.Message message, [String? text]) {
    String currentUser = user!.uid;
    print("This is the doc code $chatDocId");
    print("This is the $message");
    var gettingMessages = message.toJson();
    // for (var element in gettingMessages.values) {
    //   print("This is the element ${message(0, message).toString()}");
    //   _messages.insert(0, message);
    // }
    // setState(() {
    //   _messages.insert(0, message);
    // });
    gettingMessages.forEach((key, value) {});
    technicianApp.firestore!
        .collection("chats")
        .doc(chatDocId)
        .collection("messages")
        .add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': currentUser,
      'friendName': widget.TechnisianName,
      'msg': text.toString(),
      'sentBy':
          technicianApp.sharedPreferences!.getString(technicianApp.userName),
    });
    // setState(() {
    //   _messages.insert(0, message);
    // });
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );
      print("This is the image pic ${result.name}");
      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFile.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    print("Text message showing here ${textMessage}");

    _addMessage(textMessage, textMessage.text);
  }

  // void _loadMessages() async {
  //   User? user = technicianApp.auth!.currentUser;
  //   var currentUserId = user!.uid;

  //   // final response = await rootBundle.loadString('assets/messages.json');
  //   // final messages = (jsonDecode(response) as List)
  //   //     .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
  //   //     .toList();

  //   // setState(() {
  //   //   _messages = messages;
  //   // });
  //   // final data =
  //   //     await technicianApp.firestore!.collection("chats").get().then((value) {
  //   //   for (var element in value.docs) {
  //   //     var gettingId = element.id;
  //   //     print("This is the ID $gettingId");
  //   //     var gettingEachElement = element.data();
  //   //     gettingEachElement.forEach((key, value) {

  //   //     });
  //   //     print("This is the element $gettingEachElement");
  //   //   }
  //   // });
  //   await technicianApp.firestore!
  //       .collection("chats")
  //       .where('users', isEqualTo: {"UserID": currentUserId})
  //       .limit(1)
  //       .get()
  //       .then((result) {
  //         for (var element in result.docs) {
  //           print("This is the element $element");
  //         }
  //       });
  // }
}
