import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:technicianApp/Authentication/login.dart';
import 'package:technicianApp/Models/item.dart';
import 'package:technicianApp/config/config.dart';
import 'package:location/location.dart' as loc;
import 'package:technicianApp/userHomePages/acceptedOrders.dart';
import 'package:technicianApp/userHomePages/allOrders.dart';
import 'package:technicianApp/userHomePages/carTechnisianHistory.dart';
import 'package:technicianApp/userHomePages/editProfile.dart';
import 'package:technicianApp/userHomePages/homePageMap.dart';

class homePage extends StatefulWidget {
  @override
  _homePage createState() => _homePage();
}

var _userLatitude = 0.0;
var _userLongitude = 0.0;
var distanceInKm = 0.0;

class _homePage extends State<homePage> {
  int _selectedIndex = 0; //New
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final loc.Location location = loc.Location();

  String googleAPiKey = "AIzaSyBpLzaDvyWfvVvxD9xO3fM1i5FfCbjJ9nE";
  DateTime? backButtonPressed;

  final _pages = [
    homePageMap(),
    allOrders(),
    acceptedOrders(),
    carTechnisianHistory(),
    editProfile(),
  ];

  Future<bool> exitTwice() {
    DateTime now = DateTime.now();
    if (backButtonPressed == null ||
        now.difference(backButtonPressed!) > Duration(seconds: 2)) {
      backButtonPressed = now;
      Fluttertoast.showToast(msg: "one more to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    var gettingCurrentUser = technicianApp.auth?.currentUser.toString();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          technicianApp.sharedPreferences!
              .getString(technicianApp.userName.toString())
              .toString(),
          style: const TextStyle(
              color: Colors.white, letterSpacing: 2, fontSize: 23),
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () async {
                  await technicianApp.auth!.signOut().then((value) {
                    Route route =
                        MaterialPageRoute(builder: (context) => Login());
                    Navigator.pushReplacement(context, route);
                  });
                },
                icon: const Icon(Icons.logout_outlined),
              ),
            ],
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () => exitTwice(),
        child: Material(
          child: _pages.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        selectedIconTheme: const IconThemeData(color: Colors.blue),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'All Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending),
            label: 'Accepted Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Edit',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
