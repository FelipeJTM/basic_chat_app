import 'package:basic_chat_app/models/message.dart';
import 'package:basic_chat_app/service/database_service.dart';
import 'package:basic_chat_app/widgets/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../helper/screen_nav_helper.dart';
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
  final double adjustScrollMultiplier = -0.001;
  String? groupAdmin;
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0,
    keepScrollOffset: true,
  );

  // The variable [theListIsEmpty] its used to trigger the [_scrollController]
  // scrolling a little bit after sending a message, this depends of the number
  // of messages that already exist in the chatGroup:
  // (messagesFromDB = 0) = NO Scroll after sending message.
  // (messagesFromDB >= 1) = scroll after sending message.
  bool theListIsEmpty = true;

  @override
  void initState() {
    super.initState();
    getGroupMessages();
    getGroupAdmin();
  }

  void delayFunction() {}

  void getGroupMessages() {
    DataBaseService()
        .getGroupMessages(widget.groupInformation.getId)
        .then((val) {
      setState(() {
        groupMessages = val;
      });
    });
  }

  void scrollToTheBottom() {
    _scrollController.animateTo(
      (_scrollController.position.maxScrollExtent) * adjustScrollMultiplier,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
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
      appBar: appBar(),
      body: body(),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(widget.groupInformation.getName),
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        InkWell(
          child: IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              ScreenNavHelper.nextScreen(
                context: context,
                page: GroupInfo(
                  parameters: GroupInfoParameters(
                    groupName: widget.groupInformation.getName,
                    groupID: widget.groupInformation.getId,
                    adminName: groupAdmin!,
                    userName: widget.groupInformation.getUserSender,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget body() {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.3,
          child: chatMessages(),
        ),
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
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: groupMessages,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return const Center(child: Text("LOADING..."));
        theListIsEmpty = snapshot.data.docs.isEmpty;
        if (theListIsEmpty) return const Center(child: Text("NO MESSAGES"));
        int numberOfMessages = snapshot.data.docs.length;
        return ListView.builder(
          shrinkWrap: true,
          reverse: true,
          controller: _scrollController,
          itemCount: numberOfMessages,
          itemBuilder: (context, index) {
            return MessageTile(
              message: Message(
                snapshot.data.docs[(numberOfMessages - 1) - index]["message"],
                snapshot.data.docs[(numberOfMessages - 1) - index]["sender"],
                messageSentByMe(
                  snapshot.data.docs[(numberOfMessages - 1) - index]["sender"],
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool messageSentByMe(String snapshotSender) {
    return snapshotSender == widget.groupInformation.getUserSender;
  }

  void sendMessage() {
    if (messageSenderController.text.isEmpty) return;
    String userId = widget.groupInformation.getId;
    Map<String, dynamic> chatMessageMap = prepareMessage(
      message: messageSenderController.text,
      sender: widget.groupInformation.getUserSender,
      time: DateTime.now().millisecondsSinceEpoch,
    );
    DataBaseService().sendMessage(userId, chatMessageMap);
    setState(() => messageSenderController.clear());
    if (!theListIsEmpty) scrollToTheBottom();
  }

  Map<String, dynamic> prepareMessage({
    required dynamic message,
    required dynamic sender,
    required dynamic time,
  }) {
    return {
      "message": message,
      "sender": sender,
      "time": time,
    };
  }
}
