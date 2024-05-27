import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test/client/screens/home_screen.dart';
import 'package:test/client/screens/splash_screen.dart';
import 'package:test/client/services/google_sevice.dart';
import 'package:test/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:test/client/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Widget nextScreen = const LoginScreen();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String? token = await GoogleService().getToken();
    if (token != null) {
      setState(() {
        nextScreen = HomeScreen(
          userID: FirebaseAuth.instance.currentUser!.uid,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tareas',
        home: SplashScreen(
          icon: true,
          currentScreen: nextScreen,
          text: 'Tareas',
        ));
  }
}
