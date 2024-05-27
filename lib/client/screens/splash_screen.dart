import 'package:flutter/material.dart';
import 'package:test/shared/constants/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen(
      {super.key,
      required this.currentScreen,
      required this.icon,
      required this.text});
  final Widget currentScreen;
  final bool icon;
  final String text;

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              widget.currentScreen,
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, animation2, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [accentPurple, lightPurple],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.icon
                    ? Image.asset('assets/icons/tux.png', height: 100)
                    : const SizedBox.shrink(),
                const SizedBox(height: 20),
                Text(widget.text,
                    style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ],
            )));
  }
}
