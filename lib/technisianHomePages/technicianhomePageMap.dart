import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:technicianApp/config/config.dart';
import 'package:technicianApp/technisianHomePages/technicianChat.dart';

class technicianhomePageMap extends StatefulWidget {
  @override
  _technicianhomePageMap createState() => _technicianhomePageMap();
}

class _technicianhomePageMap extends State<technicianhomePageMap> {
  final loc.Location location = loc.Location();

  String googleAPiKey = "AIzaSyBpLzaDvyWfvVvxD9xO3fM1i5FfCbjJ9nE";
  User? user = technicianApp.auth?.currentUser;

  @override
  Widget build(BuildContext context) {
    var _userLatitude = 0.0;
    var _userLongitude = 0.0;
    var distanceInKm = 0.0;

    setState(() {
      _userLatitude;
      _userLongitude;
      distanceInKm;
    });
    var gettingLatLong = technicianApp.firestore!
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((result) {
      _userLatitude = result.data()!['lat'];
      _userLongitude = result.data()!['long'];
    });

    return Material(
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where("role", isEqualTo: "technician")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    var dictance = GeolocatorPlatform.instance.distanceBetween(
                      _userLatitude,
                      _userLongitude,
                      snapshot.data!.docs[index]['lat'],
                      snapshot.data!.docs[index]['long'],
                    );
                    distanceInKm = dictance / 1000;
                    return Column(
                      children: [
                        const Divider(
                          height: 5,
                        ),
                        ListTile(
                          isThreeLine: true,
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data!.docs[index]['url']),
                          ),
                          title: Text(
                            snapshot.data!.docs[index]['name'].toString(),
                            style: TextStyle(fontSize: 13),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "${distanceInKm.toInt().toString()}Km",
                                style: TextStyle(fontSize: 11),
                              )
                            ],
                          ),
                          dense: true,
                          iconColor: Colors.blue,
                          trailing: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.chat),
                                    onPressed: () {
                                      // Navigator.of(context).push(
                                      //   MaterialPageRoute(
                                      //     builder: (context) => technicianChat(
                                      //       technicianAppId:
                                      //           snapshot.data!.docs[index].id,
                                      //       technicianAppName: snapshot
                                      //           .data!.docs[index]['name'],
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                        Icons.assistant_direction_rounded),
                                    onPressed: () {
                                      // Navigator.of(context).push(MaterialPageRoute(
                                      //   builder: (context) =>
                                      //       newMyMap(snapshot.data!.docs[index].id),
                                      // ));
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.settings),
                                    onPressed: () {
                                      // Navigator.of(context).push(MaterialPageRoute(
                                      //   builder: (context) => servicesAvailable(
                                      //     stationName: snapshot.data!.docs[index]
                                      //         ['name'],
                                      //     statoinId: snapshot.data!.docs[index].id,
                                      //   ),
                                      // ));
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
