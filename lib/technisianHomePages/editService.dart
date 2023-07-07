import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:technicianApp/DialogBox/errorDialog.dart';
import 'package:technicianApp/DialogBox/loadingDialog.dart';
import 'package:technicianApp/config/config.dart';
import 'package:technicianApp/technisianHomePages/technicianHomePage.dart';

class editService extends StatefulWidget {
  final String serviceId;
  const editService({Key? key, required this.serviceId}) : super(key: key);

  @override
  _editServiceState createState() => _editServiceState();
}

class _editServiceState extends State<editService> {
  User? user = technicianApp.auth!.currentUser;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController serviceName = TextEditingController();
  TextEditingController serviceInfo = TextEditingController();
      TextEditingController servicePrice = TextEditingController();
  List<String> PaymentMehod = ['Gcash', 'Maya', 'COD'];
  String? value;

  // int? servicePrice;

  @override
  void initState() {
    gettingData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Getting Data
  Future gettingData() async {
    String uid = user!.uid;

    var result = await technicianApp.firestore!
        .collection("services")
        .doc(uid)
        .collection("AllServicesPerUser")
        .doc(widget.serviceId)
        .get();

    if (result != null) {
      serviceName.text = result.data()!['serviceName'];
      serviceInfo.text = result.data()!['longDescription'];
      servicePrice.text = result.data()!['price'].toString();
      value = result.data()!['PaymentMethod'];
      setState(() {
        print("This is the Data $serviceName");
      });
    } else {
      print("Sorry There is no Data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          technicianApp.sharedPreferences!
              .getString(technicianApp.TechnicianName.toString())
              .toString(),
          style: const TextStyle(
              color: Colors.white, letterSpacing: 2, fontSize: 23),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            "Edit Service",
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 33,
                letterSpacing: 1),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: serviceName,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            FontAwesome5.car_crash,
                            color: Colors.blue,
                            size: 25,
                          ),
                          labelText: "service Name"),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: serviceInfo,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            FontAwesome5.info_circle,
                            color: Colors.blue,
                            size: 25,
                          ),
                          labelText: "service Description"),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: servicePrice,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.price_change,
                            color: Colors.blue,
                            size: 27,
                          ),
                          labelText: "service Price"),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 5, bottom: 5, right: 15, left: 15),
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButton<String>(
                        value: value,
                        hint: const Text("Please select Payment method"),
                        items: PaymentMehod.map(buildMenuItem).toList(),
                        onChanged: (value) =>
                            setState(() => this.value = value),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () => serviceName.text.isNotEmpty &&
                      servicePrice.text.isNotEmpty &&
                      serviceInfo.text.isNotEmpty
                  ? updatingData()
                  : showDialog(
                      context: context,
                      builder: (c) =>
                          const ErrorAlertDialog(message: "Can't be Empty")),
              style:
                  ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
              child: const Text(
                "Save Data",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
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

  Future updatingData() async {
    User? user = technicianApp.auth!.currentUser;
    String uid = user!.uid;

    showDialog(
        context: context,
        builder: (c) => const LoadingAlertDialog(
              message: "Saving Data...",
            ));

    await technicianApp.firestore!
        .collection("services")
        .doc(uid)
        .collection("AllServicesPerUser")
        .doc(widget.serviceId)
        .update({
      "serviceName": serviceName.text.trim(),
      "longDescription": serviceInfo.text.trim(),
      "price": int.parse(servicePrice.text),
      "PaymentMethod": value,
    }).then((value) {
      Navigator.pop(context);
      Route route =
          MaterialPageRoute(builder: (context) => technicianHomePage());
      Navigator.pushReplacement(context, route);
    });
  }
}
