import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/client/screens/home_screen.dart';
import 'package:test/client/screens/login_screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logIn(
      BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(
                  userID: _auth.currentUser!.uid,
                )),
        (route) => false,
      );
    } catch (e) {
      final snackBar = SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> logOut(BuildContext context) async {
    await _auth.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
      (route) => false,
    );
  }
}
