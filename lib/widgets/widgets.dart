import 'package:flutter/material.dart';

const textInputDecorationForm = InputDecoration(
    labelStyle: TextStyle(color: Colors.black38),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFFC400), width: 2)),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFFC400), width: 2)),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFFC400), width: 2)),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFFC400), width: 2)));

InputDecoration textInputDecorationAlert = InputDecoration(
  labelStyle: TextStyle(color: Colors.black38),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFFFC400), width: 2),
    borderRadius: BorderRadius.circular(20),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFFFC400), width: 2),
    borderRadius: BorderRadius.circular(20),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFFFC400), width: 2),
    borderRadius: BorderRadius.circular(20),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFFFC400), width: 2),
    borderRadius: BorderRadius.circular(20),
  ),
);

const textStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
);

ButtonStyle buttonDecoration = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFC400)),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
      side: const BorderSide(
        color: Color(0xFFFFC400),
      ),
    ),
  ),
);

void nextScreen({required BuildContext context, required Widget page}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace({required BuildContext context, required Widget page}) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void popScreen({required BuildContext context}) {
  Navigator.pop(context);
}

void showSnackBar(
    {required BuildContext context,
    required String message,
    required Color color}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w300, color: Colors.white),
    ),
    backgroundColor: color,
    duration: const Duration(seconds: 3),
    action: SnackBarAction(
      label: "OK",
      onPressed: () {},
      textColor: Colors.white,
    ),
  ));
}


String getId(String value) {
  return value.substring(0, value.indexOf("_"));
}

String getName(String value) {
  return value.substring(value.indexOf('_') + 1);
}

