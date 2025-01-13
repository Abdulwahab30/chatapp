import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String userName = "DUH";
  String userId = "Meh";
  String userEmail = "YEA";
  var db = FirebaseFirestore.instance;

  void getUserDetails() {
    var authUser = FirebaseAuth.instance.currentUser;
    db.collection("users").doc(authUser!.uid).get().then((dataSnapshot) {
      userName = dataSnapshot.data()?["name"] ?? "";
      userId = dataSnapshot.data()?["id"] ?? "";
      userEmail = dataSnapshot.data()?["email"] ?? "";
      notifyListeners();
    });
  }
}
