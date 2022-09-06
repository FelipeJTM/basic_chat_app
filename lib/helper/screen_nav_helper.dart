import 'package:flutter/material.dart';

class ScreenNavHelper {
  static void nextScreen(
      {required BuildContext context, required Widget page}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  static void nextScreenReplace(
      {required BuildContext context, required Widget page}) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
  }

  static void popScreen({required BuildContext context}) {
    Navigator.pop(context);
  }
}
