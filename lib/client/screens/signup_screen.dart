import 'package:flutter/material.dart';
import 'package:test/client/screens/login_screen.dart';
import 'package:test/client/widgets/snack_bar.dart';
import 'package:test/shared/constants/colors.dart';
import 'package:test/shared/constants/config.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final fire_auth.FirebaseAuth _auth = fire_auth.FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool circular = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Sign Up",
                  style: TextStyle(
                      fontSize: 50.0,
                      color: darkPurple,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 80.0),
              textField("Correo", _emailController, false),
              const SizedBox(height: 20.0),
              textField("Contraseña", _passwordController, true),
              const SizedBox(height: 60.0),
              colorButton("Registrarse"),
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const LoginScreen()),
                      (route) => false);
                },
                child: const Text("¿Ya tienes una cuenta? INICIA SESIÓN",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: darkPurple,
                    )),
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
              await _auth.createUserWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text);
              setState(() {
                circular = false;
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => const LoginScreen()),
                  (route) => false);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(snackBar(
                  context, 'El correo o la contraseña son inválidos', true));
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

  Widget textField(
      String text, TextEditingController controller, bool obscureText) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - horizontalScreenPadding,
      // height: 80,
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        style: const TextStyle(
          fontSize: 18.0,
          color: almostBlack,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          hintText: text,
          filled: true,
          fillColor: lightPurple,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: accentPurple, width: 2.0),
            borderRadius: BorderRadius.circular(roundLabelRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: lightPurple, width: 2.0),
            borderRadius: BorderRadius.circular(roundLabelRadius),
          ),
        ),
      ),
    );
  }
}
