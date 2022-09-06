import 'package:flutter/material.dart';

class FormConfigData {
  final String labelText;
  final IconData icon;
  Function assignNewValue;
  final bool isItAnEmailField;
  final int inputMinLength;
  final bool hideText;

  FormConfigData({
    required this.labelText,
    required this.icon,
    required this.assignNewValue,
    this.inputMinLength = 0,
    this.isItAnEmailField = false,
    this.hideText = false,
  });
}