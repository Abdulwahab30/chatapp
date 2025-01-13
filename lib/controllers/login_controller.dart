import 'package:chatapp/screens/dashboard_screen.dart';
import 'package:chatapp/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginController {
  static Future<void> login(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

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
