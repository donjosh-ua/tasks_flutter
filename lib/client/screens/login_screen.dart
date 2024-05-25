import 'package:flutter/material.dart';
import 'package:test/client/screens/home_screen.dart';
import 'package:test/client/screens/signup_screen.dart';
import 'package:test/client/services/google_sevice.dart';
import 'package:test/client/widgets/button_icon.dart';
import 'package:test/client/widgets/text_field.dart';
import 'package:test/shared/constants/colors.dart';
import 'package:test/shared/constants/config.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final fire_auth.FirebaseAuth _auth = fire_auth.FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool circular = false;
  GoogleService authService = GoogleService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40.0),
              const Text("Login",
                  style: TextStyle(
                      fontSize: 50.0,
                      color: darkPurple,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 60.0),
              textField(context, "Correo", _emailController, false),
              const SizedBox(height: 20.0),
              textField(context, "Contraseña", _passwordController, true),
              const SizedBox(height: 5.0),
              SizedBox(
                width:
                    MediaQuery.of(context).size.width - horizontalScreenPadding,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: darkPurple,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              colorButton("Iniciar sesión"),
              const SizedBox(height: 40.0),
              const Text("O inicia sesión con",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: almostBlack,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buttonIcon("assets/icons/google_logo.png", () async {
                    await authService.googleSigIn(context);
                  }),
                  const SizedBox(
                    width: 15,
                  ),
                  buttonIcon("assets/icons/github_logo.png", () async {
                    // await authService.githubSignIn(context);
                  }),
                ],
              ),
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const SignUpScreen()),
                      (route) => false);
                },
                child: const Text("¿No tienes cuenta? CREA UNA",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: darkPurple,
                    )),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget colorButton(String text) {
    return Container(
      width: MediaQuery.of(context).size.width - horizontalScreenPadding,
      height: 80,
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - horizontalScreenPadding,
        height: 80,
        child: FloatingActionButton(
          onPressed: () async {
            setState(() {
              circular = true;
            });
            try {
              await _auth.signInWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text);
              setState(() {
                circular = false;
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (builder) =>
                          HomeScreen(userID: _auth.currentUser!.uid)),
                  (route) => false);
            } catch (e) {
              final snackBar = SnackBar(
                content: Text(e.toString()),
                duration: const Duration(seconds: 5),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              setState(() {
                circular = false;
              });
            }
          },
          backgroundColor: accentPurple,
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          child: circular
              ? const CircularProgressIndicator()
              : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}