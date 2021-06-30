class  User {

  String _id;
  String _email;
  String  _name;
  String _imgUrl;

  User.create(this._id, this._email, this._name, this._imgUrl);

  String get imgUrl => _imgUrl;

  String get name => _name;

  String get email => _email;

  String get id => _id;
}