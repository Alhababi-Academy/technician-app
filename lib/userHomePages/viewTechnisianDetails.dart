import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:technicianApp/DialogBox/loadingDialog.dart';
import 'package:technicianApp/Widgets/loadingWidget.dart';
import 'package:technicianApp/config/config.dart';

String? serviceId;
DateTime selectedDate = DateTime.now();
User? currentUser = technicianApp.auth!.currentUser;
String status = "Pending";
String technisianName = '';

class VewTechnisianDetails extends StatefulWidget {
  String TechnisianID;
  VewTechnisianDetails({Key? key, required this.TechnisianID})
      : super(key: key);

  @override
  State<VewTechnisianDetails> createState() => _VewTechnisianDetailsState();
}

class _VewTechnisianDetailsState extends State<VewTechnisianDetails> {
  Future gettingDataFromTechnisian() async {
    var gettingname = await technicianApp.firestore!
        .collection("users")
        .doc(widget.TechnisianID)
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
    return Scaffold(
      appBar: AppBar(
        title: Text(technisianName),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.TechnisianID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SliverToBoxAdapter(
              child: Center(
                child: circularProgress(),
              ),
            );
          }

          final data = snapshot.data!;

          final name = data['name'];
          final location = data['location'];
          final phoneNumber = data['phoneNumber'].toString();
          final certificateImageUrl = data.get('certificateImageUrl');
          final registeredTime = data['RegistredTime'].toString();
          final email = data['email'];
          final experience = data['experince'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0XFFE3E3E3),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 110.0,
                      width: 110.0,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(data['url']),
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    FontAwesome5.car_crash,
                                    color: Colors.blue,
                                    size: 25,
                                  ),
                                  title: Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ListTile(
                                  leading: const Icon(
                                    FontAwesome5.info_circle,
                                    color: Colors.blue,
                                    size: 25,
                                  ),
                                  title: Text(
                                    location,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ListTile(
                                  leading: const Icon(
                                    Icons.phone,
                                    color: Colors.blue,
                                    size: 27,
                                  ),
                                  title: Text(
                                    phoneNumber,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ListTile(
                                  leading: const Icon(
                                    Icons.document_scanner,
                                    color: Colors.blue,
                                    size: 27,
                                  ),
                                  title: Image.network(certificateImageUrl),
                                ),
                                const SizedBox(height: 10),
                                ListTile(
                                  leading: const Icon(
                                    Icons.timer,
                                    color: Colors.blue,
                                    size: 27,
                                  ),
                                  title: Text(
                                    registeredTime,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ListTile(
                                  leading: const Icon(
                                    Icons.email,
                                    color: Colors.blue,
                                    size: 27,
                                  ),
                                  title: Text(
                                    email,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ListTile(
                                  leading: const Icon(
                                    Icons.work,
                                    color: Colors.blue,
                                    size: 27,
                                  ),
                                  title: Text(
                                    experience,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
        .doc(widget.TechnisianID)
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
        "technicianId": widget.TechnisianID,
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
        "technicianId": widget.TechnisianID,
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
