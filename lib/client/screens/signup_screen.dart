import 'package:flutter/material.dart';
import 'package:test/client/screens/login_screen.dart';
import 'package:test/client/widgets/password_field.dart';
import 'package:test/client/widgets/snack_bar.dart';
import 'package:test/client/widgets/text_field.dart';
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text("Registro",
                    style: TextStyle(
                        fontSize: titleFontSize,
                        color: darkPurple,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 60.0),
                textField(context, "Correo", _emailController),
                const SizedBox(height: 20.0),
                PasswordField(
                  text: "Contraseña",
                  controller: _passwordController,
                ),
                const SizedBox(height: 60.0),
                colorButton("Registrarse"),
                const SizedBox(height: 10.0),
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
                        fontSize: normalFontSize,
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
}
