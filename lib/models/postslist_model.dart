class PostsResponse {
  String _code;
  String _message;
  String? _category;
  List<Post> _data;

  PostsResponse(this._code, this._message, this._category, this._data);

  factory PostsResponse.fromJson(Map<String, dynamic> parsedJson) {
    List<dynamic>? list = [];
    if (parsedJson["data"] != null) list = parsedJson['data'] as List;

    List<Post> postList = list.map((i) => Post.fromJson(i)).toList();

    return new PostsResponse(parsedJson["code"], parsedJson["msg"], parsedJson["category"], postList);
  }

  List<Post> get data => _data;

  String? get category => _category;

  String get message => _message;

  String get code => _code;

  set data(List<Post> value) {
    _data = value;
  }

  set category(String? value) {
    _category = value;
  }

  set message(String value) {
    _message = value;
  }

  set code(String value) {
    _code = value;
  }
}

class Post {
  String _cheriId;
  String _title;
  String _author;
  String _dateTime;
  String _views;
  String _imgUrl;
  String _category;
  String _categoryId;
  String _shareYN;

  Post.create(this._cheriId, this._title, this._author, this._dateTime, this._views, this._imgUrl, this._category, this._shareYN, this._categoryId);

  String get category => _category;

  String get imgUrl => _imgUrl;

  String get views => _views;

  String get dateTime => _dateTime;

  String get author => _author;

  String get title => _title;

  String get cheriId => _cheriId;

  String get categoryId => _categoryId;

  set category(String value) {
    _category = value;
  }

  set cheriId(String value) {
    _cheriId = value;
  }

  set imgUrl(String value) {
    _imgUrl = value;
  }

  set views(String value) {
    _views = value;
  }

  set categoryId(String value) {
    _categoryId = value;
  }

  String  get shareYN => _shareYN;

  set like(String   value) {
    _shareYN = value;
  }

  set dateTime(String value) {
    _dateTime = value;
  }

  set author(String value) {
    _author = value;
  }

  set title(String value) {
    _title = value;
  }

  factory Post.fromJson(Map<String, dynamic> parsedJson) {
    return Post.create(parsedJson["CHERI_ID"], parsedJson["TITLE"], "unknown", parsedJson["REG_DATE"], parsedJson["VIEWS"], 'https://cheri.weeknday.com/' + parsedJson["CHERI_PICTURE_URL"], parsedJson["CATEGORY"], parsedJson["SHARE_YN"], parsedJson["CATEGORY_ID"]);
  }
}
