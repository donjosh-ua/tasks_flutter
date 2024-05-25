import 'package:flutter/material.dart';
import 'package:test/shared/constants/colors.dart';
import 'package:test/shared/constants/config.dart';

Widget textField(
    context, String text, TextEditingController controller, bool obscureText) {
  return SizedBox(
    width: MediaQuery.of(context).size.width - horizontalScreenPadding,
    child: TextField(
      obscureText: obscureText,
      controller: controller,
      style: const TextStyle(
        fontSize: 18.0,
        color: almostBlack,
      ),
      decoration: InputDecoration(
        labelText: text,
        labelStyle: const TextStyle(
          fontSize: 18.0,
          color: darkGray,
        ),
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
