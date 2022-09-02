import 'package:flutter/material.dart';

import '../theme/constant_colors.dart';

InputDecoration textInputDecorationForm = InputDecoration(
    labelStyle: TextStyle(color: ConstantColors.basicFontColor),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ConstantColors.primaryYellow, width: 2)),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ConstantColors.primaryYellow, width: 2)),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ConstantColors.primaryYellow, width: 2)),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ConstantColors.primaryYellow, width: 2)));

InputDecoration textInputDecorationAlert = InputDecoration(
  labelStyle: TextStyle(color: ConstantColors.basicFontColor),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ConstantColors.primaryYellow, width: 2),
    borderRadius: BorderRadius.circular(20),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ConstantColors.primaryYellow, width: 2),
    borderRadius: BorderRadius.circular(20),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ConstantColors.primaryYellow, width: 2),
    borderRadius: BorderRadius.circular(20),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ConstantColors.primaryYellow, width: 2),
    borderRadius: BorderRadius.circular(20),
  ),
);

const textStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
);

ButtonStyle buttonDecoration = ButtonStyle(
  backgroundColor:
      MaterialStateProperty.all<Color>(ConstantColors.primaryYellow),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
      side: BorderSide(
        color: ConstantColors.primaryYellow,
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
      style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w300,
          color: ConstantColors.alterFontColor),
    ),
    backgroundColor: color,
    duration: const Duration(seconds: 3),
    action: SnackBarAction(
      label: "OK",
      onPressed: () {},
      textColor: ConstantColors.primaryYellow,
    ),
  ));
}

String getId(String value) {
  return value.substring(0, value.indexOf("_"));
}

String getName(String value) {
  return value.substring(value.indexOf('_') + 1);
}
