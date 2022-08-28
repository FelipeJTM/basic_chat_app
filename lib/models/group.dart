class Group{
  final String _id;
  final String _name;
  final String _userSender;

  Group(this._id, this._name, this._userSender);

  String get getId{
    return _id;
  }
  String get getName{
    return _name;
  }
  String get getUserSender{
    return _userSender;
  }

}