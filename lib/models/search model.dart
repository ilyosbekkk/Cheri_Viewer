class Search {
  String? _message;
  String? _code;
  List<SearchWord>? _searchWords;

  Search.create(this._message, this._code, this._searchWords);

  List<SearchWord>? get searchWords => _searchWords;

  String? get code => _code;

  String? get message => _message;

  factory Search.fromJson(Map<String, dynamic> parsedJson) {
    List<dynamic>? list = [];
    if(parsedJson["data"] != null)
      list = parsedJson['data'] as List;



    List<SearchWord> wordList = list.map((i) => SearchWord.fromJson(i)).toList();

    return Search.create(parsedJson["code"], parsedJson["msg"],wordList);
  }

}

class SearchWord {
  String? _wordId;
  String? _word;

  SearchWord.create(this._wordId, this._word);

  String? get word => _word;

  String? get wordId => _wordId;

  factory SearchWord.fromJson(Map<String, dynamic> parsedJson) {
    return SearchWord.create(parsedJson["ID"], parsedJson["SEARCH_WORD"]);
  }


}
