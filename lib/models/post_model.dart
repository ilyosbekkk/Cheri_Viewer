class Post {
  String _title;
  String _author;
  int _dateTime;
  int _views;
  String _imgUrl;
  String  _category;
  bool _like;

  Post.create(this._title, this._author, this._dateTime, this._views, this._imgUrl, this._category, this._like);

  Post();
  String  get category => _category;

  String get imgUrl => _imgUrl;

  int get views => _views;

  int get dateTime => _dateTime;

  String get author => _author;

  String get title => _title;

  bool get like => _like;

  set like(bool value) {
    _like = value;
  }

  set category(String value) {
    _category = value;
  }

  set imgUrl(String value) {
    _imgUrl = value;
  }

  set views(int value) {
    _views = value;
  }

  set dateTime(int value) {
    _dateTime = value;
  }

  set author(String value) {
    _author = value;
  }

  set title(String value) {
    _title = value;
  }
}

enum Category { A, B, C, D, E, F }
