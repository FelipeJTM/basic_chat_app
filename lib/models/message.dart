class Message {
  final String _content;
  final String _sender;
  final bool _sentByMe;

  Message(this._content, this._sender, this._sentByMe);

  String get getContent {
    return _content;
  }

  String get getSender {
    return _sender;
  }

  bool get isSendByMe {
    return _sentByMe;
  }
}
