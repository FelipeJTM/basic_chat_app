import 'package:basic_chat_app/helper/helper_function.dart';
import 'package:basic_chat_app/models/group.dart';
import 'package:basic_chat_app/pages/chat_page.dart';
import 'package:basic_chat_app/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearch = false;
  String? userName = "";

  //TODO: by the moment this is bugged in the scenario there are more than one groups with the same name;
  bool isJoined = false;

  ////---------------------------------------------------------------------------
  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUserIdAndName();
  }

  getCurrentUserIdAndName() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Search",
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Search groups",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                /*   IconButton(
                    hoverColor:Colors.red.withOpacity(0.5),
                    onPressed: () {
                      startSearchMethod();
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    )),*/
                GestureDetector(
                  onTap: () {
                    startSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(40)),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : groupList()
        ],
      ),
    );
  }

  startSearchMethod() async {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DataBaseService()
          .searchByName(_searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearch = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearch
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot?.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                userName: userName!,
                groupName: searchSnapshot!.docs[index]['groupName'],
                groupId: searchSnapshot!.docs[index]['groupId'],
                admin: searchSnapshot!.docs[index]['admin'],
              );
            },
          )
        : Container();
  }

  Widget groupTile({
    required String userName,
    required String groupId,
    required String groupName,
    required String admin,
  }) {
    //check if user already is in the group
    joinedOrNot(userName, groupId, groupName, admin);
    return Center(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            groupName.substring(0, 1).toUpperCase(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        title: Text(
          groupName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text("Admin: ${getName(admin)}"),
        trailing: InkWell(
          onTap: () async {
            await DataBaseService(uid: user!.uid)
                .toggleGroupJoin(groupId, userName, groupName);
            if (isJoined) {
              setState(() {
                isJoined = !isJoined;
              });
              showSnackBar(
                  context: context,
                  message: "Successfully Joined the group",
                  color: Colors.green);
              Future.delayed(const Duration(seconds: 2), () {
                nextScreen(
                    context: context,
                    page: ChatPage(
                      groupInformation: Group(groupId, groupName, userName),
                    ));
              });
            } else {
              setState(() {
                isJoined = !isJoined;
              });
              showSnackBar(
                  context: context,
                  message: "Left the group",
                  color: Colors.red);
            }
          },
          child: isJoined
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      border: Border.all(color: Colors.white, width: 1)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text(
                    "Joined",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor,
                      border: Border.all(color: Colors.white, width: 1)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text(
                    "Join Now",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }

  joinedOrNot(
      String userName, String groupId, String groupName, String admin) async {
    await DataBaseService(uid: user!.uid)
        .isUserJoined(
            groupName: groupName, groupId: groupId, userName: userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }
}
