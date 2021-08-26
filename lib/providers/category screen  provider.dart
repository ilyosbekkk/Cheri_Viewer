import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/services/web%20services.dart';

class CategoriesProvider extends ChangeNotifier {
  List<Post> _categories = [];
  bool categoryLoading = false;
  bool isScrollControllerRegistered =false;
  bool fetchRequestDone = false;


  Future<bool> fetchCategories(int pageSize, int nowPage, String orderBy, int category,  String memberId) async {
    categoryLoading = true;

    try {

      Response response = await WebServices.fetchPosts(pageSize, nowPage, orderBy, category, memberId);

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        PostsResponse postsResponse = PostsResponse.fromJson(decodedResponse);


        for(int i = 0;i<postsResponse.data.length; i++){
          print(postsResponse.data[i].cheriId);
        }

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


  void cleanCategoryScreen(){
    _categories.clear();
    categoryLoading = true;
    fetchRequestDone = false;
    isScrollControllerRegistered = false;
    notifyListeners();

  }


  List<Post> get categories => _categories;
}
