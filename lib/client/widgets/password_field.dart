import 'package:flutter/material.dart';
import 'package:test/shared/constants/colors.dart';
import 'package:test/shared/constants/config.dart';

class PasswordField extends StatefulWidget {
  final String text;
  final TextEditingController controller;

  const PasswordField({
    super.key,
    required this.text,
    required this.controller,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - horizontalScreenPadding,
      child: TextField(
        obscureText: _obscureText,
        controller: widget.controller,
        style: const TextStyle(
          fontSize: normalFontSize,
          color: almostBlack,
        ),
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: darkPurple,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
          labelText: widget.text,
          labelStyle: const TextStyle(
            fontSize: normalFontSize,
            color: darkGray,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          // hintText: widget.text,
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
