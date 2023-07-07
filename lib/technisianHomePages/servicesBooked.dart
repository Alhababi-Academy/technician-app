import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as dateFormatting;
import 'package:technicianApp/DialogBox/loadingDialog.dart';
import 'package:technicianApp/config/config.dart';
import 'package:technicianApp/technisianHomePages/viewCarHistory.dart';

class servicesBooked extends StatefulWidget {
  const servicesBooked({Key? key}) : super(key: key);

  @override
  _servicesBooked createState() => _servicesBooked();
}

class _servicesBooked extends State<servicesBooked> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  var gettingCurrentId;
  var userBooked;
  var gettingStatus;
  var serviceId;
  var idInsideUser;
  var servicdStatus;
  var statusAccepted = "Accepted";
  var statusCompleted = "Completed";
  var statusRejected = "Rejected";
  var PaymentStatus = "Paid";
  var Status;
  var Username;
  var location;
  var email;
  @override
  Widget build(BuildContext context) {
    User? currentUser = technicianApp.auth?.currentUser;
    setState(() {
      gettingStatus;
      userBooked;
      serviceId;
      servicdStatus;
      idInsideUser;
      Status;
      PaymentStatus;
    });
    return Scaffold(
      body: StreamBuilder(
          stream: technicianApp.firestore
              ?.collection("bookedServices")
              .where("technicianId", isEqualTo: currentUser!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text("Error");
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    Status = snapshot.data!.docs[index]['status'];
                    // Checking What user ordered that service
                    userBooked = snapshot.data!.docs[index]['userBooked'];
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
                                      .data!.docs[index]['thumbnailUrl']),
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
                                              snapshot.data!.docs[index]
                                                  ['userPicked'],
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
                                              snapshot.data!.docs[index]
                                                  ['userEmailPicked'],
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
                                              snapshot.data!
                                                  .docs[index]['serviceName']
                                                  .toString(),
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
                                              snapshot
                                                  .data!.docs[index]['price']
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              Status,
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              snapshot.data!.docs[index]
                                                  ['PaymentStatus'],
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Route route = MaterialPageRoute(
                                            builder: (c) => viewCarHistory(
                                              userBooked: snapshot.data!
                                                  .docs[index]['userBooked'],
                                            ),
                                          );
                                          Navigator.push(context, route);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.green),
                                        child: const Text("View"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    snapshot.data!.docs[index]['status'] !=
                                            "Accepted"
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                gettingStatus = snapshot.data!
                                                    .docs[index]['status'];
                                                gettingCurrentId = snapshot
                                                    .data!.docs[index].id;
                                                userBooked = snapshot.data!
                                                    .docs[index]['userBooked'];
                                                serviceId = snapshot.data!
                                                    .docs[index]['serviceId'];
                                                servicdStatus = snapshot.data!
                                                    .docs[index]['status'];
                                                Status = snapshot.data!
                                                    .docs[index]['status'];
                                                accept();
                                              },
                                              child: const Text("Accept"),
                                            ),
                                          )
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                gettingStatus = snapshot.data!
                                                    .docs[index]['status'];
                                                gettingCurrentId = snapshot
                                                    .data!.docs[index].id;
                                                userBooked = snapshot.data!
                                                    .docs[index]['userBooked'];
                                                serviceId = snapshot.data!
                                                    .docs[index]['serviceId'];
                                                servicdStatus = snapshot.data!
                                                    .docs[index]['status'];
                                                Status = snapshot.data!
                                                    .docs[index]['status'];
                                                completed();
                                              },
                                              child: const Text(
                                                  "Mark as Compelete"),
                                            ),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          gettingStatus = snapshot
                                              .data!.docs[index]['status'];
                                          gettingCurrentId =
                                              snapshot.data!.docs[index].id;
                                          userBooked = snapshot
                                              .data!.docs[index]['userBooked'];
                                          serviceId = snapshot.data!.docs[index]
                                              ['serviceId'];
                                          servicdStatus = snapshot
                                              .data!.docs[index]['status'];
                                          Status = snapshot.data!.docs[index]
                                              ['status'];
                                          markAsPaid();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.green),
                                        child: const Text("Mark as Paid"),
                                      ),
                                    ),
                                    snapshot.data!.docs[index]['status'] ==
                                            "Pending"
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                gettingStatus = snapshot.data!
                                                    .docs[index]['status'];
                                                gettingCurrentId = snapshot
                                                    .data!.docs[index].id;
                                                userBooked = snapshot.data!
                                                    .docs[index]['userBooked'];
                                                serviceId = snapshot.data!
                                                    .docs[index]['serviceId'];
                                                servicdStatus = snapshot.data!
                                                    .docs[index]['status'];
                                                Status = snapshot.data!
                                                    .docs[index]['status'];
                                                reject();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.red),
                                              child: const Text("Recject"),
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Text("Empty Data");
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          }),
    );
  }

  Future accept() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const LoadingAlertDialog(
              message: "Loading",
            )).then((value) {
      Future.delayed(const Duration(seconds: 2));
    });
    if (gettingStatus == "Pending" || gettingStatus == "Rejected") {
      await technicianApp.firestore!
          .collection("bookedServices")
          .doc(gettingCurrentId)
          .update({
        "status": statusAccepted,
      });
      var gettingSOmething = await technicianApp.firestore!
          .collection("users")
          .doc(userBooked)
          .collection("servicesBooked")
          .where('serviceId', isEqualTo: serviceId)
          .get()
          .then((value) async {
        var id = await value.docs[0].id;
        idInsideUser = id;
        setState(() {
          idInsideUser;
          servicdStatus;
        });
      });

      await technicianApp.firestore!
          .collection("users")
          .doc(userBooked)
          .collection("servicesBooked")
          .doc(idInsideUser)
          .update({
        "status": statusAccepted,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Service was Accepted"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("It's already Accepted"),
      ));
    }
    Navigator.pop(context);
  }

  Future completed() async {
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Write a Comment'),
        content: TextField(
          controller: commentController,
          decoration: InputDecoration(hintText: 'Enter your comment'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String comment = commentController.text;
              // Do something with the comment, e.g., save it to Firestore
              markingItAsComplete(comment);
              Navigator.pop(context);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  // As Complete
  markingItAsComplete(String comment) async {
    String? currentUser = technicianApp.auth?.currentUser?.uid;
    await technicianApp.firestore!
        .collection("bookedServices")
        .doc(gettingCurrentId)
        .update({
      "status": statusCompleted,
    });
    var gettingSOmething = await technicianApp.firestore!
        .collection("users")
        .doc(userBooked)
        .collection("servicesBooked")
        .where('serviceId', isEqualTo: serviceId)
        .get()
        .then((value) async {
      var id = await value.docs[0].id;
      idInsideUser = id;
      setState(() {
        idInsideUser;
        servicdStatus;
      });
    });

    await technicianApp.firestore!
        .collection("users")
        .doc(userBooked)
        .collection("servicesBooked")
        .doc(idInsideUser)
        .update({
      "status": statusCompleted,
    }).then((value) async {
      await technicianApp.firestore!.collection("history").add({
        "technisianID": currentUser,
        "dateOfFixing": dateFormatting.DateFormat("dd-MM-yyyy")
            .format(DateTime.now())
            .toString(),
        "userID": userBooked,
        "comment": comment,
        "technisianName": technicianApp.sharedPreferences!
            .getString(technicianApp.TechnicianName.toString())
            .toString(),
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Service was Accepted"),
    ));
  }

  Future reject() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const LoadingAlertDialog(
              message: "Loading",
            )).then((value) {
      Future.delayed(const Duration(seconds: 2));
    });
    if (gettingStatus == "Pending" || gettingStatus == "Accepted") {
      await technicianApp.firestore!
          .collection("bookedServices")
          .doc(gettingCurrentId)
          .update({
        "status": statusRejected,
      });
      var gettingSOmething = await technicianApp.firestore!
          .collection("users")
          .doc(userBooked)
          .collection("servicesBooked")
          .where('serviceId', isEqualTo: serviceId)
          .get()
          .then((value) async {});

      await technicianApp.firestore!
          .collection("users")
          .doc(userBooked)
          .collection("servicesBooked")
          .doc(idInsideUser)
          .update({
        "status": statusRejected,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Service was Rejected"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("It's already Rejected"),
      ));
    }
    Navigator.pop(context);
  }

  // Mark As Paid
  Future markAsPaid() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const LoadingAlertDialog(
              message: "Loading",
            )).then((value) {
      Future.delayed(const Duration(seconds: 2));
    });
    if (gettingStatus != "Pending") {
      await technicianApp.firestore!
          .collection("bookedServices")
          .doc(gettingCurrentId)
          .update({
        "PaymentStatus": PaymentStatus,
      });
      var gettingSOmething = await technicianApp.firestore!
          .collection("users")
          .doc(userBooked)
          .collection("servicesBooked")
          .where('serviceId', isEqualTo: serviceId)
          .get()
          .then((value) async {});

      await technicianApp.firestore!
          .collection("users")
          .doc(userBooked)
          .collection("servicesBooked")
          .doc(idInsideUser)
          .update({
        "PaymentStatus": PaymentStatus,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Service was Marked as Paid"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("It's already Paid"),
      ));
    }
    Navigator.pop(context);
  }
}
