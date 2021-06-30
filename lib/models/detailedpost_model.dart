class DetailedPostResponse {
  String? _code;
  String? _msg;
  DetailedPost? _detailedPosts;

  DetailedPostResponse(this._code, this._msg, this._detailedPosts);

  factory DetailedPostResponse.fromJson(Map<String, dynamic> parsedJson) {


    DetailedPost dataList =DetailedPost.fromJson(parsedJson["data"]);
    return DetailedPostResponse(parsedJson["code"], parsedJson["msg"],dataList);
  }

  DetailedPost? get detailedPosts => _detailedPosts;

  String? get msg => _msg;

  String? get code => _code;
}

class DetailedPost {
  String? _cherId;
  String? _title;
  String? _categoryId;
  String? _share;
  String? _regDate;
  String? _pictureId;
  String? _views;
  String? _categoryName;
  String? _picture;
  String? _nickName;
  String? _saveCount;
  String? _saveYn;
  String? _hashTag;

  DetailedPost(this._cherId, this._title, this._categoryId, this._share, this._regDate, this._pictureId, this._views, this._categoryName, this._picture, this._nickName, this._saveCount, this._saveYn, this._hashTag);

  String? get hashTag => _hashTag;

  String? get saveYn => _saveYn;

  String? get saveCount => _saveCount;

  String? get nickName => _nickName;

  String? get picture => _picture;

  String? get categoryName => _categoryName;

  String? get views => _views;

  String? get pictureId => _pictureId;

  String? get regDate => _regDate;

  String? get share => _share;

  String? get categoryId => _categoryId;

  String? get title => _title;

  String? get cherId => _cherId;

  factory DetailedPost.fromJson(Map<String, dynamic> parsedJson) {
    return DetailedPost(parsedJson["CHERI_ID"], parsedJson["TITLE"], parsedJson["CATEGORY_ID"], parsedJson["SHARE"], parsedJson["REG_DAT"], parsedJson["PICTURE_ID"], parsedJson["VIEWS"], parsedJson["CATEGORY"], parsedJson["PICTURE"], parsedJson["NAME"], parsedJson["SAVECOUNT"], parsedJson["SAVE_YN"], parsedJson["Hashtag"]);
  }
}
