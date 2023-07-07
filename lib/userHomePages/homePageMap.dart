import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:technicianApp/config/config.dart';
import 'package:technicianApp/userHomePages/Services.dart';
import 'package:technicianApp/userHomePages/customChat.dart';
import 'package:technicianApp/userHomePages/newMap.dart';
import 'package:technicianApp/userHomePages/viewTechnisianDetails.dart';

class homePageMap extends StatefulWidget {
  @override
  _homePageMap createState() => _homePageMap();
}

class _homePageMap extends State<homePageMap> {
  final loc.Location location = loc.Location();

  String googleAPiKey = "AIzaSyBpLzaDvyWfvVvxD9xO3fM1i5FfCbjJ9nE";
  User? user = technicianApp.auth?.currentUser;
  var gettingImageUrl;
  var _userLatitude = 0.0;
  var _userLongitude = 0.0;
  var distanceInKm = 0.0;
  var dictance;
  var gettingLatLong;
  var gettingCurrentTechId;

  // for the search
  String searching = "";

  gettingUserCurrentLocation() async {
    gettingLatLong = await technicianApp.firestore!
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((result) {
      setState(() {
        _userLatitude = result.data()!['lat'];
        _userLongitude = result.data()!['long'];
      });
    });
  }

  @override
  void initState() {
    gettingUserCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _userLatitude;
      _userLongitude;
      distanceInKm;
      dictance;
    });

    return Material(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searching = value;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                hintText: 'Search',
                prefixIcon: Icon(
                  Icons.search,
                ),
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where("role", isEqualTo: "technician")
                  .orderBy('lat')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    String name = snapshot.data?.docs[index]['name'];
                    dictance = GeolocatorPlatform.instance.distanceBetween(
                      _userLatitude,
                      _userLongitude,
                      snapshot.data!.docs[index]['lat'],
                      snapshot.data!.docs[index]['long'],
                    );
                    distanceInKm = dictance / 1000;
                    if (name.toString().toLowerCase().startsWith(searching)) {
                      return Column(
                        children: [
                          const Divider(
                            height: 5,
                          ),
                          ListTile(
                            isThreeLine: true,
                            leading: GestureDetector(
                              onTap: () {
                                Route route = MaterialPageRoute(
                                  builder: (_) => VewTechnisianDetails(
                                    TechnisianID: snapshot.data!.docs[index].id,
                                  ),
                                );
                                Navigator.push(context, route);
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  snapshot.data!.docs[index]['url'] == ''
                                      ? '0'
                                      : snapshot.data!.docs[index]['url'],
                                ),
                              ),
                            ),
                            title: Text(
                              snapshot.data!.docs[index]['name'].toString(),
                              style: const TextStyle(fontSize: 13),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  "${distanceInKm.toInt().toString()}Km Dictance",
                                  style: const TextStyle(fontSize: 11),
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
                                      icon: const Icon(FontAwesome.chat),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => customChat(
                                              technisianId: snapshot
                                                  .data!.docs[index]['uid'],
                                              TechnisianName: snapshot
                                                  .data!.docs[index]['name'],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(FontAwesome.location),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => newMyMap(
                                                snapshot.data!.docs[index].id),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(FontAwesome5.car_crash),
                                      onPressed: () {
                                        gettingCurrentTechId =
                                            snapshot.data!.docs[index].id;
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                servicesAvailable(
                                              statoinId: gettingCurrentTechId,
                                            ),
                                          ),
                                        );
                                        print(
                                            "This is the Technisian ID $gettingCurrentTechId");
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
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
