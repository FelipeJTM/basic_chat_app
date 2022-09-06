import 'package:basic_chat_app/pages/profile_page.dart';
import 'package:basic_chat_app/pages/search_page.dart';
import 'package:basic_chat_app/service/auth_service.dart';
import 'package:basic_chat_app/service/database_service.dart';
import 'package:basic_chat_app/widgets/general_purpose_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/screen_nav_helper.dart';
import '../helper/string_format_helper.dart';
import '../service/shared_preferences_service.dart';
import '../theme/form_decorations.dart';
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
    getUserData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Groups",
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                //authService.signOut();
                ScreenNavHelper.nextScreen(context: context, page: const SearchPage());
              },
              icon: const Icon(Icons.search))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              leading: const Icon(Icons.group),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: const Text(
                "Groups",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                ScreenNavHelper.nextScreenReplace(
                    context: context,
                    page: ProfilePage(
                      userName: userName,
                      email: email,
                    ));
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: false,
              leading: const Icon(Icons.person_pin),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: const Text(
                "Profile",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to leave?"),
                        actions: [
                          ElevatedButton(
                            style: FormDecorations.buttonDecoration.copyWith(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).primaryColor)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            style: FormDecorations.buttonDecoration,
                            onPressed: () async {
                              authServiceInstance.signOut().then((_) =>
                                  ScreenNavHelper.nextScreenReplace(
                                      page: const LoginPage(),
                                      context: context));
                              //Navigator.pop(context);
                            },
                            child: const Text("Logout"),
                          )
                        ],
                      );
                    });
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: false,
              leading: const Icon(Icons.exit_to_app),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: const Text(
                "Exit",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            )
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          popMenu(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void getUserData() async {
    await SharedPreferenceService.getUserEmailFromSF().then(
      (value) {
        setState(
          () {
            email = (value != null) ? value : "the data was null";
          },
        );
      },
    );
    await SharedPreferenceService.getUserNameFromSF().then(
      (value) {
        setState(
          () {
            userName = (value != null) ? value : "the data was null";
          },
        );
      },
    );
    // getting the list of snapshot in our stream
    await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groupsSnapshot = snapshot;
      });
    });
  }

  groupList() {
    return StreamBuilder(
      stream: groupsSnapshot,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data["groups"].length,
                itemBuilder: (context, index) {
                  int reversedIndex = snapshot.data["groups"].length - index-1;
                  return GroupTile(
                    groupName: StringFormatHelper.getName(snapshot.data["groups"][reversedIndex]),
                    userName: snapshot.data["fullName"],
                    groupId: StringFormatHelper.getId(snapshot.data["groups"][reversedIndex]),
                  );
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
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
            onTap: () {
              popMenu(context);
            },
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

  popMenu(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Create a group"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (_isLoading)
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
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
            ),
            actions: [
              ElevatedButton(
                style: FormDecorations.buttonDecoration.copyWith(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: FormDecorations.buttonDecoration,
                onPressed: () async {
                  if (groupName != "") {
                    setState(() {
                      _isLoading = true;
                    });
                    var uid = FirebaseAuth.instance.currentUser!.uid;
                    DataBaseService(uid: uid)
                        .createGroup(
                            userName: userName, id: uid, groupName: groupName)
                        .whenComplete(() {
                      setState(() {
                        _isLoading = false;
                      });
                    });
                    Navigator.pop(context);
                    GeneralPurposeWidget.showSnackBar(
                        context: context,
                        message: "Group \"$groupName\" created successfully",
                        color: Colors.green);
                  }
                },
                child: const Text("Create"),
              )
            ],
          );
        });
  }
}
