import 'package:flutter/material.dart';

class LoadingWidgets {
  static Widget simpleCircle(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}