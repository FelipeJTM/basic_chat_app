import 'package:flutter/material.dart';

import '../models/message.dart';

class MessageTile extends StatefulWidget {
  final Message message;

  const MessageTile({Key? key, required this.message}) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.message.isSendByMe ? 0 : 24,
          right: widget.message.isSendByMe ? 24 : 0),
      alignment: widget.message.isSendByMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: widget.message.isSendByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: widget.message.isSendByMe
            ? BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                color: widget.message.isSendByMe
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700])
            : BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: widget.message.isSendByMe
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            widget.message.getSender.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            widget.message.getContent,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          )
        ]),
      ),
    );
  }
}
