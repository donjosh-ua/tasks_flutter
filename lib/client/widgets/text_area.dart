import 'package:flutter/material.dart';
import 'package:test/shared/constants/colors.dart';
import 'package:test/shared/constants/config.dart';

Widget textArea(
    context, String text, String hint, TextEditingController controller) {
  return SizedBox(
    width: MediaQuery.of(context).size.width - horizontalScreenPadding,
    height: 200,
    child: TextField(
      controller: controller,
      maxLines: 10,
      style: const TextStyle(
        fontSize: normalFontSize,
        color: almostBlack,
      ),
      decoration: InputDecoration(
        labelText: text,
        labelStyle: const TextStyle(
          fontSize: normalFontSize,
          color: darkGray,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        hintText: hint,
        filled: true,
        fillColor: lightPurple,
        floatingLabelBehavior: FloatingLabelBehavior.always,
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
