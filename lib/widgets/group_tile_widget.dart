import 'package:basic_chat_app/models/group.dart';
import 'package:flutter/material.dart';

import '../helper/screen_nav_helper.dart';
import '../models/group_tile_parameters.dart';
import '../pages/chat_page.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;

  const GroupTile(
      {Key? key,
      required this.userName,
      required this.groupId,
      required this.groupName})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScreenNavHelper.nextScreen(
            context: context,
            page: ChatPage(
              groupInformation:
                  Group(widget.groupId, widget.groupName, widget.userName),
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Join the conversation as ${widget.userName}"),
        ),
      ),
    );
  }
}

class GroupTileWidget {

  static Widget groupTile({
    required BuildContext ctx,
    required GroupTileParameters groupTileParams,
  }) {
    return GestureDetector(
      onTap: () {
        ScreenNavHelper.nextScreen(
            context: ctx,
            page: ChatPage(
              groupInformation: Group(groupTileParams.groupId,
                  groupTileParams.groupName, groupTileParams.groupName),
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(ctx).primaryColor,
            child: Text(
              groupTileParams.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            groupTileParams.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle:
              Text("Join the conversation as ${groupTileParams.groupName}"),
        ),
      ),
    );
  }
}


