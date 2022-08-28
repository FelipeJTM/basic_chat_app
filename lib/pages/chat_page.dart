import 'package:basic_chat_app/models/message.dart';
import 'package:basic_chat_app/service/database_service.dart';
import 'package:basic_chat_app/widgets/message_tile.dart';
import 'package:basic_chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/group.dart';
import 'group_info.dart';

class ChatPage extends StatefulWidget {
  final Group groupInformation;

  const ChatPage({Key? key, required this.groupInformation}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? groupMessages;
  TextEditingController messageSenderController = TextEditingController();
  String? groupAdmin;

  @override
  void initState() {
    super.initState();
    getGroupMessages();
    getGroupAdmin();
  }

  void getGroupMessages() {
    DataBaseService()
        .getGroupMessages(widget.groupInformation.getId)
        .then((val) {
      setState(() {
        groupMessages = val;
      });
    });
  }

  void getGroupAdmin() {
    DataBaseService()
        .getGroupAdmin(widget.groupInformation.getId)
        .then((value) {
      setState(() {
        groupAdmin = value;
      });
    });
  }

  @override
  void dispose() {
    messageSenderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupInformation.getName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          InkWell(
            child: IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                nextScreen(
                    context: context,
                    page: GroupInfo(
                      groupName: widget.groupInformation.getName,
                      groupId: widget.groupInformation.getId,
                      adminName: groupAdmin!,
                      userName: widget.groupInformation.getUserSender,
                    ));
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: messageSenderController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Send a message...",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                      border: InputBorder.none,
                    ),
                  )),
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: groupMessages,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: Message(
                    snapshot.data.docs[index]["message"],
                    snapshot.data.docs[index]["sender"],
                    messageSentByMe(
                        snapshotSender: snapshot.data.docs[index]["sender"]),
                  ));
                })
            : const Center(
                child: Text("NO MESSAGES"),
              );
      },
    );
  }

  bool messageSentByMe({required String snapshotSender}) {
    return snapshotSender == widget.groupInformation.getUserSender;
  }

  sendMessage() {
    if (messageSenderController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageSenderController.text,
        "sender": widget.groupInformation.getUserSender,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DataBaseService()
          .sendMessage(widget.groupInformation.getId, chatMessageMap);
    }
    setState(() {
      messageSenderController.clear();
    });
  }
}
