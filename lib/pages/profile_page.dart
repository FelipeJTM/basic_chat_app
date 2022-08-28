import 'package:basic_chat_app/pages/home_page.dart';
import 'package:flutter/material.dart';

import '../service/auth_service.dart';
import '../widgets/widgets.dart';
import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;

  ProfilePage({Key? key, required this.userName, required this.email})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            "Profile",
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
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
                widget.userName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              ListTile(
                onTap: () {
                  nextScreen(context: context, page: const HomePage());
                },
                selectedColor: Theme.of(context).primaryColor,
                selected: false,
                leading: const Icon(Icons.group),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                title: const Text(
                  "Groups",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              ListTile(
                onTap: () {},
                selectedColor: Theme.of(context).primaryColor,
                selected: true,
                leading: const Icon(Icons.person_pin),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                title: const Text(
                  "Profile",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
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
                          content:
                              const Text("Are you sure you want to leave?"),
                          actions: [
                            ElevatedButton(
                              style: buttonDecoration.copyWith(
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
                              style: buttonDecoration,
                              onPressed: () async {
                                authService.signOut().then((_) =>
                                    nextScreenReplace(
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
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 150, horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 200,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Full name", style: TextStyle(fontSize: 17)),
                    Text(widget.userName, style: const TextStyle(fontSize: 17)),
                  ],

                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Email", style: TextStyle(fontSize: 17)),
                    Text(widget.email, style: const TextStyle(fontSize: 17)),
                  ],

                ),
              ],
            ),
          ),
        ));
  }
}
