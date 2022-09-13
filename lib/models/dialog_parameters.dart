import 'package:flutter/cupertino.dart';

class DialogParameters {
  final String title;
  final Widget content;
  final Function onPressed;
  final String? okButtonText;

  DialogParameters({
    required this.title,
    required this.content,
    required this.onPressed,
    this.okButtonText
  });
}