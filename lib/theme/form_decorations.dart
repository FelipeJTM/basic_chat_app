
import 'package:flutter/material.dart';

import 'constant_colors.dart';

class FormDecorations{
  static InputDecoration textInputDecorationForm = InputDecoration(
      labelStyle: TextStyle(color: ConstantColors.basicFontColor),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ConstantColors.primaryYellow, width: 2)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ConstantColors.primaryYellow, width: 2)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ConstantColors.primaryYellow, width: 2)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ConstantColors.primaryYellow, width: 2)));

  static InputDecoration textInputDecorationAlert = InputDecoration(
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
  static ButtonStyle buttonDecoration = ButtonStyle(
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
  static const textStyle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
  );
}