import 'package:basic_chat_app/widgets/drawer/drawer_components.dart';
import 'package:flutter/material.dart';
import '../../helper/screen_nav_helper.dart';
import '../../models/dialog_parameters.dart';
import '../../models/drawer_data.dart';
import '../../models/drawer_tile_parameters.dart';
import '../../pages/login_page.dart';
import '../general_custom_widget.dart';
import 'drawer_user_info.dart';

enum Selected {
  groups,
  profile,
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key, required this.drawerData});

  final DrawerData drawerData;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          DrawerUserInfo(displayName: drawerData.userName),
          const SizedBox(height: 30),
          DrawerTile(
            tileParams: DrawerTileParameters(
              onTap: drawerData.groupFunction,
              isSelected:
                  (drawerData.currentPage == Selected.groups) ? true : false,
              selectedColor: Theme.of(context).primaryColor,
              icon: Icons.group,
              title: "Groups",
            ),
          ),
          DrawerTile(
            tileParams: DrawerTileParameters(
                onTap: drawerData.profileFunction,
                isSelected:
                    (drawerData.currentPage == Selected.profile) ? true : false,
                selectedColor: Theme.of(context).primaryColor,
                icon: Icons.person_pin,
                title: "Profile"),
          ),
          DrawerTile(
            tileParams: DrawerTileParameters(
              onTap: () {
                showExitDialog(ctx: context);
              },
              isSelected: false,
              selectedColor: Theme.of(context).primaryColor,
              icon: Icons.exit_to_app,
              title: "Exit",
            ),
          ),
        ],
      ),
    );
  }

  void showExitDialog({required BuildContext ctx}) {
    showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (context) {
        return GeneralPurposeWidget.generalDialog(
          ctx: context,
          dialogParams: DialogParameters(
            title: "Logout",
            content: const Text("Are you sure you want to leave?"),
            onPressed: () async {
              drawerData.authServiceInstance.signOut().then((_) =>
                  ScreenNavHelper.nextScreenReplace(
                      page: const LoginPage(), ctx: context));
            },
          ),
        );
      },
    );
  }
}
