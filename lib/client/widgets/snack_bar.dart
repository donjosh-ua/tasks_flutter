import 'package:flutter/material.dart';
import 'package:test/shared/constants/colors.dart';
import 'package:test/shared/constants/config.dart';

SnackBar snackBar(BuildContext context, String message, bool error) {
  return SnackBar(
    backgroundColor: error ? lightRed : lightGreen,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(roundButtonRadius),
    ),
    behavior: SnackBarBehavior.floating,
    content: Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 16.0),
      ),
    ),
    duration: const Duration(seconds: 3),
  );
}
