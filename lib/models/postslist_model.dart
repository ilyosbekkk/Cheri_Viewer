


class PostsResponse {

  int  _code;
  String _message;
  String _category;
  List<Post> _data;

  PostsResponse(this._code, this._message, this._category, this._data);

  factory PostsResponse.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['images'] as List;
    print(list.runtimeType);
    List<Post> postList = list.map((i) => Post.fromJson(i)).toList();
    return new PostsResponse(parsedJson["code"], parsedJson["msg"], parsedJson["category"], postList);
  }


}



class Post {
  String _title;
  String _author;
  String  _dateTime;
  String  _views;
  String _imgUrl;
  String  _category;
  bool _like;

  Post.create(this._title, this._author, this._dateTime, this._views, this._imgUrl, this._category, this._like);

  Post();
  String  get category => _category;

  String get imgUrl => _imgUrl;

  String  get views => _views;

  String  get dateTime => _dateTime;

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

  set dateTime(String  value) {
    _dateTime = value;
  }

  set author(String value) {
    _author = value;
  }

  set title(String value) {
    _title = value;
  }

  factory Post.fromJson(Map<String, dynamic> parsedJson){
    return Post.create(
      parsedJson["TITLE"],
      "unknown",
      parsedJson["REG_DATE"],
      parsedJson["VIEWS"],


    );
  }


}


enum Category { A, B, C, D, E, F }
