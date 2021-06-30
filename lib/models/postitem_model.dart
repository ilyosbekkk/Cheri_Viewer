class ItemsResponse {
  String? _code;
  String? _msg;
  List<Item>? _items;

  ItemsResponse(this._code, this._msg, this._items);

  List<Item>? get items => _items;

  String? get msg => _msg;

  String? get code => _code;

  factory ItemsResponse.fromJson(Map<String, dynamic> parsedJson) {
    List<dynamic>? list = [];
    if(parsedJson["data"] != null)
      list = parsedJson['data'] as List;



    List<Item> itemsList = list.map((i) => Item.fromJson(i)).toList();
    return new ItemsResponse(parsedJson["code"], parsedJson["msg"], itemsList);
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
