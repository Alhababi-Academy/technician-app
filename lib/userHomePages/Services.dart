import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:technicianApp/DialogBox/loadingDialog.dart';
import 'package:technicianApp/Models/item.dart';
import 'package:technicianApp/Widgets/loadingWidget.dart';
import 'package:technicianApp/config/config.dart';

String? serviceId;
DateTime selectedDate = DateTime.now();
User? currentUser = technicianApp.auth!.currentUser;
String status = "Pending";
String technisianName = '';

class servicesAvailable extends StatefulWidget {
  String statoinId;
  servicesAvailable({Key? key, required this.statoinId}) : super(key: key);

  @override
  State<servicesAvailable> createState() => _servicesAvailableState();
}

class _servicesAvailableState extends State<servicesAvailable> {
  Future gettingDataFromTechnisian() async {
    var gettingname = await technicianApp.firestore!
        .collection("users")
        .doc(widget.statoinId)
        .get();

    if (gettingname.exists) {
      technisianName = gettingname.data()!['name'];
      setState(() {
        technisianName;
      });
    }
  }

  @override
  void initState() {
    gettingDataFromTechnisian();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      serviceId;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(technisianName),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("services")
                .doc(widget.statoinId)
                .collection("AllServicesPerUser")
                .snapshots(),
            builder: (context, snapshot) {
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
                                  color: const Color(0XFFE3E3E3)),
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
                                      padding: const EdgeInsets.all(8.0),
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
                                          const SizedBox(
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
                                          const SizedBox(
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
                                          const SizedBox(
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
                                                    .data!
                                                    .docs[index]
                                                        ['PaymentMethod']
                                                    .toString(),
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
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            serviceId =
                                                snapshot.data?.docs[index].id;

                                            uploadData(serviceId);
                                          },
                                          child: const Text("Book"),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: Container(
                                      //     decoration: BoxDecoration(
                                      //         borderRadius:
                                      //             BorderRadius.circular(5),
                                      //         color: Colors.blue),
                                      //     // color: Colors.blue,
                                      //     padding: const EdgeInsets.all(5),
                                      //     // child: Text(
                                      //     //   snapshot.data!
                                      //     //       .docs[index]['PaymentStatus']
                                      //     //       .toString(),
                                      //     //   style:
                                      //     //       TextStyle(color: Colors.white),
                                      //     // ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
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

  // uploadData(String? serviceId) async {
  //   final DateTime? selected = await showDatePicker(
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2050),
  //     context: context,
  //     initialDate: selectedDate,
  //   );

  //   if (selected != null && selected != selectedDate) {
  //     setState(() {
  //       selectedDate = selected;
  //       print("Selected Date $selectedDate");
  //       print("This is the id ${currentUser?.uid}");
  //     });
  //     showDialog(
  //       context: context,
  //       builder: (c) => const LoadingAlertDialog(
  //         message: "Booking Please Wait",
  //       ),
  //     );
  //     sendDataUser(serviceName, longDescription, thumbnailUrl, price, context);
  //     sendDataAdmin(serviceName, longDescription, thumbnailUrl, price, context);
  //   }
  // }

  uploadData(String? serviceId) async {
    User? user = technicianApp.auth!.currentUser;
    String uid = user!.uid;
    var serviceName;
    var longDescription;
    var thumbnailUrl;
    var price;
    var gettingData = await technicianApp.firestore!
        .collection("services")
        .doc(widget.statoinId)
        .collection("AllServicesPerUser")
        .doc(serviceId)
        .get();

    if (gettingData.exists) {
      serviceName = gettingData.data()!['serviceName'];
      longDescription = gettingData.data()!['longDescription'];
      thumbnailUrl = gettingData.data()!['thumbnailUrl'];
      price = gettingData.data()!['price'];
      print("This is the Servie Name $serviceName");
      showDialog(
          context: context,
          builder: (c) => const LoadingAlertDialog(
                message: "Loading",
              ));

      await technicianApp.firestore
          ?.collection("users")
          .doc(uid)
          .collection("servicesBooked")
          .add({
        "userBooked": uid,
        "DateBooking": DateTime.now(),
        "serviceId": serviceId.toString(),
        "serviceName": serviceName.toString(),
        "longDescription": longDescription.toString(),
        "thumbnailUrl": thumbnailUrl.toString(),
        "price": price,
        "technicianId": widget.statoinId,
        "technicianName": technisianName,
        "status": status.toString(),
        "userPicked":
            technicianApp.sharedPreferences!.getString(technicianApp.userName),
        "userEmailPicked":
            technicianApp.sharedPreferences!.getString(technicianApp.userEmail),
        "PaymentStatus": "NotPaid",
      });
      await technicianApp.firestore?.collection("bookedServices").add({
        "userBooked": uid,
        "DateBooking": DateTime.now(),
        "serviceId": serviceId.toString(),
        "serviceName": serviceName.toString(),
        "serviceDes": longDescription.toString(),
        "thumbnailUrl": thumbnailUrl.toString(),
        "price": price,
        "technicianId": widget.statoinId,
        "technicianName": technisianName,
        "status": status.toString(),
        "userPicked":
            technicianApp.sharedPreferences!.getString(technicianApp.userName),
        "userEmailPicked":
            technicianApp.sharedPreferences!.getString(technicianApp.userEmail),
        "PaymentStatus": "NotPaid",
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Booked Successfully"),
      ));

      Navigator.pop(context);
    }
  }
}
