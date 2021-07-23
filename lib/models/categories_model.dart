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

class Category{

  String? _menuId;
  String? _topCategory;
  String? _category;
  String? _categoryId;

  Category.create(this._menuId, this._topCategory, this._category, this._categoryId);

  String? get categoryId => _categoryId;

  String? get category => _category;

  String? get topCategory => _topCategory;

  String? get menuId => _menuId;

  factory Category.fromJson(Map<String, dynamic> parsedJson) {
    return Category.create(parsedJson["MENU_ID"],  parsedJson["TOP_CATEGORY"], parsedJson["CATEGORY"], parsedJson["CATEGORY_ID"]);
  }

}