import 'package:basic_chat_app/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';
import 'home_page.dart';

class GroupInfo extends StatefulWidget {
  const GroupInfo(
      {Key? key,
      required this.groupName,
      required this.groupId,
      required this.adminName,
      required this.userName,
      })
      : super(key: key);
  final String groupName;
  final String groupId;
  final String adminName;
  final String userName;

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;

  @override
  void initState() {
    // TODO: implement initState
    getMembers();
    super.initState();
  }

  getMembers() async {
    DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupsMembers(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String r) {
    return r.substring(0, r.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Info"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text(
                            "Are you sure you want to exit the group?"),
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
                              DataBaseService(
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .toggleGroupJoin(
                                      widget.groupId,
                                      getName(widget.userName),
                                      widget.groupName)
                                  .whenComplete(() {
                                nextScreenReplace(
                                    context: context, page: const HomePage());
                              });
                            },
                            child: const Text("Exit"),
                          )
                        ],
                      );
                    });
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).primaryColor.withOpacity(0.2)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Admin: ${getName(widget.adminName)}"),
                    ],
                  ),
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  //TODO replace this if with something else.
  memberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              if (snapshot.data['members'].length != 0) {
                return ListView.builder(
                  itemCount: snapshot.data['members'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            getName(snapshot.data['members'][index])
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(getName(snapshot.data['members'][index])),
                        subtitle: Text(getId(snapshot.data['members'][index])),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("NO MEMBERS YET"),
                );
              }
            } else {
              return const Center(
                child: Text("NO MEMBERS YET"),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
        });
  }
}
