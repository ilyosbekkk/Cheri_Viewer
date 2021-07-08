import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/business_logic/services/web services.dart';

class CategoriesProvider extends ChangeNotifier {
  List<Post> _categories = [];
  bool categoryLoading = false;

  Future<bool> fetchCategories(int pageSize, int nowPage, String orderBy, int category) async {
    categoryLoading = true;

    try {
      if (_categories.isNotEmpty) _categories.clear();
      Response response = await WebServices.fetchPosts(pageSize, nowPage, orderBy, category);

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        PostsResponse postsResponse = PostsResponse.fromJson(decodedResponse);
        categoryLoading = false;
        _categories.addAll(postsResponse.data);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      notifyListeners();
      return false;
    }
  }


  List<Post> get categories => _categories;
}
