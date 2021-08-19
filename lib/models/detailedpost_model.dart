class DetailedPostResponse {
  String? _code;
  String? _msg;
  Intro? _detailedPosts;
  List<Item> _items;
  List<File> _files;
  String? _encryptedId;

  DetailedPostResponse(this._code, this._msg, this._detailedPosts, this._items, this._files, this._encryptedId);

  factory DetailedPostResponse.fromJson(Map<String, dynamic> parsedJson) {
    //detailed view
    Intro dataList = Intro.fromJson(parsedJson["data"]);

    //item data
    List<dynamic>? list1 = [];
    if (parsedJson["item_data"] != null) list1 = parsedJson['item_data'] as List;
    List<Item> itemsList = list1.map((i) => Item.fromJson(i)).toList();

    //file data
    List<dynamic>? list2 = [];
    if (parsedJson["file_data"] != null) list2 = parsedJson['file_data'] as List;

    List<File> filesList = list2.map((i) => File.fromJson(i)).toList();

    print("file  data:");
    print(parsedJson["item_data"]);
    return DetailedPostResponse(parsedJson["code"], parsedJson["msg"], dataList, itemsList, filesList, parsedJson["encrypt_id"]);
  }

  Intro? get detailedPosts => _detailedPosts;

  List<Item> get items => _items;

  String? get msg => _msg;

  String? get code => _code;

  String? get encryptedId => _encryptedId;

  List<File> get files => _files;
}

class Intro {
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
  String? _hashTag = "";
  String? _comment;
  String? _memberId;

  Intro.create(this._cherId, this._title, this._categoryId, this._share, this._regDate, this._pictureId, this._views, this._categoryName, this._picture, this._nickName, this._saveCount, this._saveYn, this._hashTag, this._comment, this._memberId);

  Intro();

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

  String? get comment => _comment;

  String? get memberId => _memberId;

  factory Intro.fromJson(Map<String, dynamic> parsedJson) {
    return Intro.create(parsedJson["CHERI_ID"], parsedJson["TITLE"], parsedJson["CATEGORY_ID"], parsedJson["SHARE"], parsedJson["REG_DATE"], parsedJson["PICTURE_ID"], parsedJson["VIEWS"], parsedJson["CATEGORY"], parsedJson["PICTURE"], parsedJson["NAME"], parsedJson["SAVECOUNT"], parsedJson["SAVE_YN"], parsedJson["hashtag"], parsedJson["COMMENT"], parsedJson["MEMBER_ID"]);
  }
}
class Item {
  String? _itemId;
  String? _contents;
  String? _order;
  String? _checkedYn;
  String? _importantYn;
  String? _regDate;
  String? _comment;
  String? _fileName;
  String? _filePath;
  String? _fileCheck;
  String? _reference;
  String? _saveFileName;

  Item(this._itemId, this._contents, this._order, this._checkedYn, this._importantYn, this._regDate, this._comment, this._fileName, this._filePath, this._fileCheck, this._reference, this._saveFileName);

  String? get saveFileName => _saveFileName;

  String? get reference => _reference;

  String? get fileCheck => _fileCheck;

  String? get filePath => _filePath;

  String? get fileName => _fileName;

  String? get comment => _comment;

  String? get regDate => _regDate;

  String? get importantYn => _importantYn;

  String? get checkedYn => _checkedYn;

  String? get order => _order;

  String? get contents => _contents;

  String? get itemId => _itemId;

  factory Item.fromJson(Map<String, dynamic> parsedJson) {
    return Item(parsedJson["ITEM_ID"], parsedJson["CONTENTS"], parsedJson["order"], parsedJson["CHECKED_YN"], parsedJson["IMPORTANT_YN"], parsedJson["REG_DATE"], parsedJson["COMMENT"], parsedJson["FILE_NAME"], parsedJson["FILE_PATH"], parsedJson["FILE_CHECK"], parsedJson["REFERENCE"], parsedJson["SAVE_FILE_NAME"]);
  }
}
class File {
  String _itemId;
  String _filePath;
  String _uploadFileName;
  String _saveFileName;
  String _fileExtension;
  String _mimeTypeMain;
  String _mimeTypeSub;
  String _fileSize;

  File.create(this._itemId, this._filePath, this._uploadFileName, this._saveFileName, this._fileExtension, this._mimeTypeMain, this._mimeTypeSub, this._fileSize);

  factory File.fromJson(Map<String, dynamic> parsedJson) {



    return File.create(parsedJson["CHERI_ITEM_ID"], parsedJson["FILE_PATH"], parsedJson["UPLOAD_FILE_NAME"], parsedJson["SAVE_FILE_NAME"], parsedJson["FILE_EXTENSION"], parsedJson["MIME_TYPE_MAIN"], parsedJson["MIME_TYPE_SUB"], parsedJson["FILE_SIZE"]);
  }

  String get fileSize => _fileSize;

  String get mimeTypeSub => _mimeTypeSub;

  String get mimeTypeMain => _mimeTypeMain;

  String get fileExtension => _fileExtension;

  String get saveFileName => _saveFileName;

  String get uploadFileName => _uploadFileName;

  String get filePath => _filePath;

  String get itemId => _itemId;
}
