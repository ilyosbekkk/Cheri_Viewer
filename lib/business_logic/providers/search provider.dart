import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:viewerapp/business_logic/services/web services.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/models/search%20model.dart';

class SearchProvider extends ChangeNotifier {
  List<Post> _searchResults = [];
  List<SearchWord> _recentSearches = [];
  List<SearchWord> _relatedSearches = [];

  Future<bool> searchPostByTitle(int pageSize, int nowPage, String orderBy, String searchWord, String memberId) async {
    if (_searchResults.isNotEmpty) _searchResults.clear();
    try {
      Response response = await WebServices.searchPostByTitle(pageSize, nowPage, orderBy, searchWord, memberId);
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        PostsResponse postsResponse = PostsResponse.fromJson(decodedResponse);
        print("result");
        print(decodedResponse);
        _searchResults.addAll(postsResponse.data);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> fetchRecentSearches(String memberId) async {
    bool result = false;
    if (_recentSearches.isNotEmpty) _recentSearches.clear();
    try {
      Response response = await WebServices.fetchRecentSearches(memberId);
      Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        Search search = Search.fromJson(decodedResponse);
        _recentSearches.addAll(search.searchWords!);
        print(decodedResponse);
        result = true;
        notifyListeners();
      }
      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> fetchRelatedSearches(String memberId, String searchWord) async {
    bool result = false;
    if (_relatedSearches.isNotEmpty) _relatedSearches.clear();
    try {
      Response response = await WebServices.fetchRelatedSearches(memberId, searchWord);
      Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        Search search = Search.fromJson(decodedResponse);
        print("related searches:");
        print(decodedResponse);
        _relatedSearches.addAll(search.searchWords!);
        result = true;
        notifyListeners();
      }
      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  List<Post> get searchResults => _searchResults;

  List<SearchWord> get relatedSearches => _relatedSearches;

  List<SearchWord> get recentSearches => _recentSearches;

  void cleanList() {
    if (_searchResults.isNotEmpty) _searchResults.clear();
  }


}
