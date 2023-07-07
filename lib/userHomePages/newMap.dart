import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class newMyMap extends StatefulWidget {
  final String user_id;
  newMyMap(this.user_id);
  @override
  _newMyMap createState() => _newMyMap();
}

class _newMyMap extends State<newMyMap> {
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (_added) {
          mymap(snapshot);
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return GoogleMap(
          mapType: MapType.normal,
          markers: {
            Marker(
              position: LatLng(
                snapshot.data!.docs[0]['lat'],
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.user_id)['long'],
              ),
              markerId: const MarkerId('id'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueMagenta),
              infoWindow: InfoWindow(
                title: snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.user_id)['name'],
              ),
            ),
          },
          initialCameraPosition: CameraPosition(
              target: LatLng(
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.user_id)['lat'],
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.user_id)['long'],
              ),
              zoom: 14.47),
          onMapCreated: (GoogleMapController controller) async {
            setState(
              () {
                _controller = controller;
                _added = true;
              },
            );
          },
        );
      },
    ));
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['latitude'],
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['longitude'],
            ),
            zoom: 14.47)));
  }
}
