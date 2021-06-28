class  Categories{

  String?  _code;
  String? _msg;
  List<Category>? _categories;

  Categories(this._code, this._msg, this._categories);


  factory Categories.fromJson(Map<String, dynamic>  parsedJson) {
    List<dynamic>? list = [];
    if(parsedJson["data"] != null)
      list = parsedJson['data'] as List;



    List<Category> postList = list.map((i) => Category.fromJson(i)).toList();

    return new Categories(parsedJson["code"], parsedJson["msg"], postList);
  }

  List<Category>? get categories => _categories;

  String? get msg => _msg;

  String? get code => _code;
}

class  Category{

  String? _menu_id;
  String? _top_category;
  String? _category;
  String? _category_id;

  Category(this._menu_id, this._top_category, this._category, this._category_id);

  String? get category_id => _category_id;

  String? get category => _category;

  String? get top_category => _top_category;

  String? get menu_id => _menu_id;

  factory Category.fromJson(Map<String, dynamic> parsedJson) {
    return Category(parsedJson["MENU_ID"],  parsedJson["TOP_CATEGORY"], parsedJson["CATEGORY"], parsedJson["CATEGORY_ID"]);
  }

}