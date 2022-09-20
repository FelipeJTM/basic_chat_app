import 'package:basic_chat_app/helper/string_format_helper.dart';
import 'package:basic_chat_app/models/app_bar_parameters.dart';
import 'package:basic_chat_app/service/shared_preferences_service.dart';
import 'package:basic_chat_app/models/group.dart';
import 'package:basic_chat_app/pages/chat_page.dart';
import 'package:basic_chat_app/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helper/screen_nav_helper.dart';
import '../models/search_group_parameters.dart';
import '../widgets/general_custom_widget.dart';
import '../widgets/loading_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchBarController = TextEditingController();
  bool isSearchingGroups = false;
  QuerySnapshot? searchSnapshot;
  bool showSearchingResults = false;
  String? userName = "";
  List<bool> isJoinedTheGroup = [];
  String? userId;

  @override
  void initState() {
    super.initState();
    assignUserData();
  }

  void assignUserData() async {
    String? userNameReturned = await getUserName();
    setState(() {
      userName = userNameReturned;
      userId = getUserId();
    });
  }

  Future<String?> getUserName() async {
    return await SharedPreferenceService.getUserNameFromSP();
  }

  String? getUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
    );
  }

  AppBar appBar() {
    return GeneralPurposeWidget.appBar(
      ctx: context,
      appBarParameters: AppBarParameters(
        title: "Search",
        actions: [],
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        searchBar(),
        mainContent(),
      ],
    );
  }

  Widget searchBar() {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchBarController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Search groups",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              startSearchGroupMethod();
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
    );
  }

  void startSearchGroupMethod() async {
    if (!_searchBarController.text.isNotEmpty) return;
    toggleLoadingIndicator();
    dynamic searchResults =
        await DataBaseService().searchByName(_searchBarController.text);
    setState(() {
      searchSnapshot = searchResults;
      showSearchingResults = true;
    });
    toggleLoadingIndicator();
  }

  void toggleLoadingIndicator() {
    setState(() {
      isSearchingGroups = !isSearchingGroups;
    });
  }

  Widget mainContent() {
    return (isSearchingGroups)
        ? LoadingWidgets.simpleCircle(context)
        : groupList();
  }

  Widget groupList() {
    return showSearchingResults
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot?.docs.length,
            itemBuilder: (context, index) {
              isJoinedTheGroup.add(false);
              return groupTile(
                params: SearchedGroupParameters(
                  userName: userName!,
                  groupName: searchSnapshot!.docs[index]['groupName'],
                  groupId: searchSnapshot!.docs[index]['groupId'],
                  admin: searchSnapshot!.docs[index]['admin'],
                  currentGroupIndexFromList: index,
                ),
              );
            },
          )
        : Container();
  }

  Widget groupTile({required SearchedGroupParameters params}) {
    joinedOrNotTheCurrentGroup(
      params.userName,
      params.groupId,
      params.groupName,
      params.admin,
      params.currentGroupIndexFromList,
    );
    return Center(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            params.groupName.substring(0, 1).toUpperCase(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        title: Text(
          params.groupName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text("Admin: ${StringFormatHelper.getName(params.admin)}"),
        trailing: InkWell(
          onTap: () => toggleJoinOrLeftGroup(groupParameters: params),
          child: isJoinedTheGroup[params.currentGroupIndexFromList]
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

  void toggleJoinOrLeftGroup({required SearchedGroupParameters groupParameters}) async {
    joinOrLeftGroup(groupParameters: groupParameters);
    toggleJoinedGroup(groupIndex: groupParameters.currentGroupIndexFromList);
    if (isJoinedTheGroup[groupParameters.currentGroupIndexFromList]) {
      joinedGroupActionPerformed(groupParameters: groupParameters);
    } else {
      leftGroupActionPerformed();
    }
  }

  void joinOrLeftGroup({required SearchedGroupParameters groupParameters}) async {
    await DataBaseService(uid: userId).toggleGroupJoin(
      groupParameters.groupId,
      groupParameters.userName,
      groupParameters.groupName,
    );
  }

  void joinedGroupActionPerformed({required SearchedGroupParameters groupParameters}) {
    GeneralPurposeWidget.showSnackBar(
        context: context,
        message: "Successfully Joined the group",
        color: Colors.green);
    Future.delayed(const Duration(seconds: 2), () {
      ScreenNavHelper.nextScreen(
          context: context,
          page: ChatPage(
            groupInformation: Group(groupParameters.groupId,
                groupParameters.groupName, groupParameters.userName),
          ));
    });
  }

  void leftGroupActionPerformed() {
    GeneralPurposeWidget.showSnackBar(
        context: context, message: "Left the group", color: Colors.red);
  }

  void toggleJoinedGroup({required int groupIndex}) {
    setState(() {
      isJoinedTheGroup[groupIndex] = !isJoinedTheGroup[groupIndex];
    });
  }

  void joinedOrNotTheCurrentGroup(
    String userName,
    String groupId,
    String groupName,
    String admin,
    int currentGroupIndexFromList,
  ) async {
    await DataBaseService(uid: userId)
        .isUserJoined(
            groupName: groupName, groupId: groupId, userName: userName)
        .then((value) {
      setState(() {
        isJoinedTheGroup[currentGroupIndexFromList] = value;
      });
    });
  }
}
