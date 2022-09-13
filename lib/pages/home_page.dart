import 'package:basic_chat_app/pages/profile_page.dart';
import 'package:basic_chat_app/pages/search_page.dart';
import 'package:basic_chat_app/service/auth_service.dart';
import 'package:basic_chat_app/service/database_service.dart';
import 'package:basic_chat_app/widgets/general_purpose_widget.dart';
import 'package:basic_chat_app/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/screen_nav_helper.dart';
import '../helper/string_format_helper.dart';
import '../models/dialog_parameters.dart';
import '../models/drawer_tile_parameters.dart';
import '../models/group_tile_parameters.dart';
import '../service/shared_preferences_service.dart';
import '../theme/form_decorations.dart';
import '../widgets/drawer_widgets.dart';
import '../widgets/group_tile_widget.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authServiceInstance = AuthService();
  Stream? groupsSnapshot;
  var userName = "";
  var email = "";
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    assignUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(),
      body: groupList(),
      floatingActionButton: floatingActionButton(),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text(
        "Groups",
        style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
            onPressed: () => goToSearchPage(), icon: const Icon(Icons.search))
      ],
    );
  }

  Drawer drawer() {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          DrawerWidgets.userInfo(displayName: userName),
          const SizedBox(height: 30),
          DrawerWidgets.drawerTile(
              ctx: context,
              tileParams: DrawerTileParameters(
                onTap: () {},
                isSelected: true,
                icon: Icons.group,
                title: "Groups",
              )),
          DrawerWidgets.drawerTile(
              ctx: context,
              tileParams: DrawerTileParameters(
                  onTap: goToProfilePage,
                  isSelected: false,
                  icon: Icons.person_pin,
                  title: "Profile")),
          DrawerWidgets.drawerTile(
              ctx: context,
              tileParams: DrawerTileParameters(
                  onTap: showExitDialog,
                  isSelected: false,
                  icon: Icons.exit_to_app,
                  title: "Exit")),
        ],
      ),
    );
  }

  Widget groupList() {
    return StreamBuilder(
      stream: groupsSnapshot,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return LoadingWidgets.simpleCircle(context);
        if (verifyList(snapshot.data['groups'])) return noGroupWidget();
        return ListView.builder(
          itemCount: snapshot.data["groups"].length,
          itemBuilder: (context, index) {
            int reversedIndex = snapshot.data["groups"].length - index - 1;
            return GroupTileWidget.groupTile(
                ctx: context,
                groupTileParams: GroupTileParameters(
                  userName: snapshot.data["fullName"],
                  groupId: StringFormatHelper.getId(
                    snapshot.data["groups"][reversedIndex],
                  ),
                  groupName: StringFormatHelper.getName(
                    snapshot.data["groups"][reversedIndex],
                  ),
                ));
          },
        );
      },
    );
  }

  FloatingActionButton floatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () => showCreateGroupDialog(context),
      child: const Icon(Icons.add),
    );
  }

  Widget noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => showCreateGroupDialog(context),
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[300],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You don't joined any groups yet, tap on the add button to create a group or tap the search icon at the top to find groups.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void assignUserData() async {
    assignEmail(await getEmail());
    assignUserName(await getUserName());
    assignGroupSnapshot(await getGroupSnapshot());
  }

  Future<String?> getEmail() async {
    return await SharedPreferenceService.getUserEmailFromSF();
  }

  void assignEmail(var newValue) {
    setState(() {
      email = (newValue != null) ? newValue : "the data was null";
    });
  }

  Future<String?> getUserName() async {
    return await SharedPreferenceService.getUserNameFromSF();
  }

  void assignUserName(var newValue) {
    setState(() {
      userName = (newValue != null) ? newValue : "the data was null";
    });
  }

  Future<Stream> getGroupSnapshot() async {
    return await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups();
  }

  void assignGroupSnapshot(Stream snapshot) {
    setState(() {
      groupsSnapshot = snapshot;
    });
  }

  void goToSearchPage() {
    ScreenNavHelper.nextScreen(context: context, page: const SearchPage());
  }

  void goToProfilePage() {
    ScreenNavHelper.nextScreenReplace(
        ctx: context,
        page: ProfilePage(
          userName: userName,
          email: email,
        ));
  }

  void showExitDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return GeneralPurposeWidget.generalDialog(
            ctx: context,
            dialogParams: DialogParameters(
              title: "Logout",
              content: const Text("Are you sure you want to leave?"),
              onPressed: () async {
                authServiceInstance.signOut().then((_) =>
                    ScreenNavHelper.nextScreenReplace(
                        page: const LoginPage(), ctx: context));
              },
            ),
          );
        });
  }

  void showCreateGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return GeneralPurposeWidget.generalDialog(
          ctx: context,
          dialogParams: DialogParameters(
              title: "Create Group",
              content: createGroupContent(),
              onPressed: onPressCreateGroup),
        );
      },
    );
  }


  Widget createGroupContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        (_isLoading)
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor))
            : const SizedBox.shrink(),
        TextField(
          onChanged: (value) {
            setState(() {
              groupName = value;
            });
          },
          decoration: FormDecorations.textInputDecorationAlert,
        ),
      ],
    );
  }

  void onPressCreateGroup() async {
    if (groupName != "") {
      toggleIsLoading();
      var uid = FirebaseAuth.instance.currentUser!.uid;
      await DataBaseService(uid: uid)
          .createGroup(userName: userName, id: uid, groupName: groupName);
      toggleIsLoading();
      dismissDialog();
      GeneralPurposeWidget.showSnackBar(
          context: context,
          message: "Group \"$groupName\" created successfully",
          color: Colors.green);
    }
  }

  void toggleIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void dismissDialog() {
    Navigator.pop(context);
  }

  bool verifyList(List? list) {
    if (list == null || list.isEmpty) return true;
    return false;
  }

}
