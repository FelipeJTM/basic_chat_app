import 'package:flutter/material.dart';
import '../../models/drawer_tile_parameters.dart';
import '../../theme/drawer_decorations.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({super.key, required this.tileParams});
  final DrawerTileParameters tileParams;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(tileParams.icon),
      selected: tileParams.isSelected,
      selectedColor: tileParams.selectedColor,
      contentPadding: DrawerDecorations.contentPadding,
      title: Text(tileParams.title, style: DrawerDecorations.titleStile),
      onTap: () => tileParams.onTap(),
    );
  }
}

