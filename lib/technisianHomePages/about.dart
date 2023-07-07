import 'package:flutter/material.dart';
import 'package:technicianApp/config/config.dart';

class about extends StatelessWidget {
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
      body: Text("sadf"),
    );
  }
}
