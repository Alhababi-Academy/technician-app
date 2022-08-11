import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class technicianApp {
  static User? user;
  static FirebaseAuth? auth;
  static FirebaseFirestore? firestore;
  static SharedPreferences? sharedPreferences;

  static const String userName = 'user';
  static const String userEmail = 'email';
  static const String gender = 'gender';
  static const String phoneNumber = 'phoneNumber';
  static const String role = 'role';
  static const String location = 'location';
  static String userUID = 'uid';

  static const String imageUrl = "imageUrl";

  static const String TechnicianName = 'userTechnician';
  static const String TechnicianEmail = 'emailTechnician';
  static const String TechnicianDesciption = 'descriptionTechnician';
  static const String TechnicianuserUID = 'uidTechnician';
  static const String TechnicianAddress = 'address';
  static const String TechnicianUrl = 'url';
}
