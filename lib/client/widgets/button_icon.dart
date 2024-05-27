import 'package:flutter/material.dart';
import 'package:test/shared/constants/colors.dart';
import 'package:test/shared/constants/config.dart';

Widget buttonIcon(String iconDir, Function() onPressed) {
  return SizedBox(
    width: buttonIconSize,
    height: buttonIconSize,
    child: Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(roundButtonRadius),
        side: const BorderSide(color: accentPurple, width: 3.0),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Image.asset(iconDir),
        iconSize: 80.0,
        color: accentPurple,
      ),
      // Image.asset(iconDir),
    ),
  );
}
