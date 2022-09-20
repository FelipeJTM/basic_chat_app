
import 'package:flutter/cupertino.dart';

class DrawerTileParameters {
  final Function onTap;
  final bool isSelected;
  final Color selectedColor;
  final IconData icon;
  final String title;

  DrawerTileParameters(
      {required this.onTap,
        required this.isSelected,
        required this.selectedColor,
        required this.icon,
        required this.title});
}