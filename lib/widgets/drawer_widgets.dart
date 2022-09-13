import 'package:flutter/material.dart';

import '../models/drawer_tile_parameters.dart';
import '../theme/drawer_decorations.dart';

class DrawerWidgets {
  static Widget userInfo({required String displayName}) {
    return Column(
      children: [
        Icon(
          Icons.account_circle,
          size: 150,
          color: Colors.grey[700],
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          displayName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  static Widget drawerTile({required BuildContext ctx,required DrawerTileParameters tileParams}) {
    return ListTile(
      leading: Icon(tileParams.icon),
      selected: tileParams.isSelected,
      selectedColor: Theme.of(ctx).primaryColor,
      contentPadding: DrawerDecorations.contentPadding,
      title: Text(tileParams.title, style: DrawerDecorations.titleStile),
      onTap: () => tileParams.onTap(),
    );
  }
}

