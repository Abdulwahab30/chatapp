import 'package:chatapp/screens/dashboard_screen.dart';
import 'package:chatapp/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupController {
  static Future<void> createAccount(
      {required BuildContext context,
      required String email,
      required String password,
      required String name,
      required String country}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      var userId = FirebaseAuth.instance.currentUser!.uid;
      var db = FirebaseFirestore.instance;

      Map<String, dynamic> data = {
        "name": name,
        "country": country,
        "email": email,
        "id": userId.toString(),
      };
      try {
        await db.collection("users").doc(userId.toString()).set(data);
      } catch (e) {
        print(e);
      }
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return const SplashScreen();
      }), (route) {
        return false;
      });
      // ignore: avoid_print
      print("Acoount created");
    } catch (e) {
      SnackBar msgSnackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(msgSnackBar);
      // ignore: avoid_print
      print(e);
    }
  }
}
