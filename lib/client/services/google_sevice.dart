import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test/client/screens/home_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test/client/screens/splash_screen.dart';

class GoogleService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          '95258763986-92qqnn4nsvq202nhs7fcamkcbbt5olsc.apps.googleusercontent.com',
      scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);

  Future<void> googleSigIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount == null) return;

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        storeTokenAndData(userCredential);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (builder) => SplashScreen(
                    currentScreen: HomeScreen(userID: _auth.currentUser!.uid),
                    icon: false,
                    text: 'Bienvenido')),
            (route) => false);
      } catch (e) {
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 5),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> storeTokenAndData(UserCredential userCredential) async {
    await _storage.write(
        key: 'token', value: userCredential.credential!.token.toString());
    await _storage.write(
        key: 'userCredential', value: userCredential.toString());
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> logOut(context) async {
    try {
      await _googleSignIn.signOut();
      await _storage.delete(key: 'token');
      await _storage.delete(key: 'userCredential');
      await _auth.signOut();
    } catch (e) {
      final snackBar = SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
