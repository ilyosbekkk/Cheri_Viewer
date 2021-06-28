import 'dart:convert';


import 'package:http/http.dart';
import 'package:viewerapp/models/categories_model.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:flutter/foundation.dart';

import '../services/web_services.dart';

class PostListsProvider extends ChangeNotifier {
  bool _showSubCategories1 = false;
  bool _showSubCategories2 = false;
  String postsMessage = "";
  String categoriesMessage = "";
  List<Post> allPosts = [];
  List<Post> categoryPosts = [];
  List<Post> searchResults = [];
  List<Post> bookMarkedPosts = [];

  List<String> subCategories1 = [];
  List<String> subCategories2 = [];
  List<String> subCategories3 = [];
  List<String> subCategories4 = [];
  List<String> subCategories5 = [];
  List<String> catId1 = [];
  List<String> catId2 = [];
  List<String> catId3 = [];
  List<String> catId4 = [];
  List<String> catId5 = [];


  int lastButtonIndex = -1;
  List<bool> _activeCategories = [false, false, false, false, false, false];

  Future<bool> fetchPostsList(
      int pageSize, int nowPage, String orderBy, int category) async {
    try {

      if(categoryPosts.isNotEmpty)
        categoryPosts.clear();
      Response response =
          await WebServices.fetchPosts(pageSize, nowPage, orderBy, category);

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse =
            json.decode(utf8.decode(response.bodyBytes));
        PostsResponse postsResponse = PostsResponse.fromJson(decodedResponse);

        postsMessage = postsResponse.message;
        if (category == 0)
          allPosts.addAll(postsResponse.data);
        else
          categoryPosts.addAll(postsResponse.data);
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

  Future<bool> searchPostByTitle(
      int pageSize, int nowPage, String orderBy, String searchWord) async {
    if (searchResults.isNotEmpty) searchResults.clear();
    try {
      Response response = await WebServices.searchPostByTitle(
          pageSize, nowPage, orderBy, searchWord);
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse =
            json.decode(utf8.decode(response.bodyBytes));
        print(decodedResponse);
        PostsResponse postsResponse = PostsResponse.fromJson(decodedResponse);
        print(postsResponse.data);

        searchResults.addAll(postsResponse.data);
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

  Future<bool> fetchSavedPostsList() async {
    return true;
  }

  Future<bool> fetchOpenedPostsList() async {
    return true;
  }

  Future<bool> fetchCategoriesList() async {
    Response response = await WebServices.fetchCategoriesList("cheri");
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedResponse =
          json.decode(utf8.decode(response.bodyBytes));

      Categories categories = Categories.fromJson(decodedResponse);
      categoriesMessage = categories.msg!;

      subCategories1.clear();
      subCategories2.clear();
      subCategories3.clear();
      subCategories4.clear();
      subCategories5.clear();
      for (int i = 0; i < categories.categories!.length; i++) {
        switch (categories.categories![i].menu_id) {
          case "1":
            subCategories1.add(categories.categories![i].category!);
            catId1.add(categories.categories![i].category_id!);
            break;
          case "2":
            subCategories2.add(categories.categories![i].category!);
            catId2.add(categories.categories![i].category_id!);

            break;
          case "4":
            subCategories3.add(categories.categories![i].category!);
            catId3.add(categories.categories![i].category_id!);

            break;
          case "6":
            subCategories4.add(categories.categories![i].category!);
            catId4.add(categories.categories![i].category_id!);

            break;
          case "7":
            subCategories5.add(categories.categories![i].category!);
            catId5.add(categories.categories![i].category_id!);

            break;
        }
      }
    }

    return true;
  }

  void save(Post post) {
    print("like pressed");
    post.like = true;
    notifyListeners();
  }

  void unsave(Post post) {
    print("unlike pressed");
    post.like = false;
    notifyListeners();
  }

  bool get showSubCategories1 => _showSubCategories1;

  bool get showSubCategories2 => _showSubCategories2;

  void showCategories(int index) {
    if (lastButtonIndex == index) {
      if (index == 4)
        _showSubCategories2 = false;
      else
        _showSubCategories1 = false;
      lastButtonIndex = -1;
      _activeCategories[index] = false;
    } else {
      for (int i = 0; i < _activeCategories.length; i++) {
        _activeCategories[i] = false;
      }

      _activeCategories[index] = true;
      lastButtonIndex = index;
      if (index == 4) {
        _showSubCategories2 = true;
        _showSubCategories1 = false;
      } else {
        _showSubCategories1 = true;
        _showSubCategories2 = false;
      }
    }
    notifyListeners();
  }

  List<String> subCategories(int index) {

    switch (index) {
      case 0:
        return subCategories1;
      case 1:
        return subCategories2;
      case 2:
        return subCategories3;
      case 3:
        return subCategories4;
      case 4:
        return subCategories5;
    }
    return [];
  }
  List<String> categoryIds(int index) {

    switch (index) {
      case 0:
        return catId1;
      case 1:
        return catId2;
      case 2:
        return catId3;
      case 3:
        return catId4;
      case 4:
        return catId5;
    }
    return [];
  }

  List<bool> get activeAcategories => _activeCategories;
}
