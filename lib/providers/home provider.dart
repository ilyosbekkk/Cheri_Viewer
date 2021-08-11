import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:viewerapp/models/categories_model.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:flutter/foundation.dart';

import 'package:viewerapp/services/web%20services.dart';

class HomeProvider extends ChangeNotifier {
  bool _showSubCategories1 = false;
  bool _showSubCategories2 = false;
  int responseCode1 = 0;
  int responseCode2 = 0;
  String categoriesMessage = "";
  bool  _networkCallDone = false;
  bool _scrollControllerRegistered = false;
  List<Post> allPosts = [];

  int activeIndex = -1;
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

  Future<bool> fetchPostsList(int pageSize, int nowPage, String orderBy, int category, String memberId ) async {

    try {

      Response response = await WebServices.fetchPosts(pageSize, nowPage, orderBy, category, memberId);
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        PostsResponse postsResponse = PostsResponse.fromJson(decodedResponse);

        print(decodedResponse);


        allPosts.addAll(postsResponse.data);
        responseCode1 = response.statusCode;
        notifyListeners();
        return true;
      } else {
        responseCode1 = response.statusCode;
        notifyListeners();
        return false;
      }
    } on TimeoutException catch (e) {
      responseCode1 = -1;
      notifyListeners();
      print("Timeout exception $e");
      return false;
    } on SocketException catch (e) {
      responseCode1 = -2;
      notifyListeners();
      print("SocketException $e");
      return false;
    } on Error catch (e) {
      responseCode1 = -3;
      notifyListeners();
      print("General Error: $e");
      return false;
    }
  }


  Future<bool> fetchLatestVersion() async{
    var  response = await  WebServices.fetchDeviceVersion();
    print(response.body);
    return false;

  }

  Future<bool> fetchCategoriesList() async {
    try {
      Response response = await WebServices.fetchCategoriesList("cheri");

      print("categories");
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));

        Categories categories = Categories.fromJson(decodedResponse);
        subCategories1.clear();
        subCategories2.clear();
        subCategories3.clear();
        subCategories4.clear();
        subCategories5.clear();
        for (int i = 0; i < categories.categories!.length; i++) {
          switch (categories.categories![i].menuId) {
            case "1":
              subCategories1.add(categories.categories![i].category!);
              catId1.add(categories.categories![i].categoryId!);
              break;
            case "2":
              subCategories2.add(categories.categories![i].category!);
              catId2.add(categories.categories![i].categoryId!);

              break;
            case "4":
              subCategories3.add(categories.categories![i].category!);
              catId3.add(categories.categories![i].categoryId!);

              break;
            case "6":
              subCategories4.add(categories.categories![i].category!);
              catId4.add(categories.categories![i].categoryId!);

              break;
            case "7":
              subCategories5.add(categories.categories![i].category!);
              catId5.add(categories.categories![i].categoryId!);

              break;
          }
        }

        responseCode2 = response.statusCode;
        notifyListeners();

        return true;
      } else {
        responseCode2 = response.statusCode;
        notifyListeners();
        return false;
      }
    } on TimeoutException catch (e) {
      responseCode2 = -1;
      notifyListeners();
      print("Timeout exception $e");
      return false;
    } on SocketException catch (e) {
      responseCode2 = -2;
      notifyListeners();
      print("SocketException $e");
      return false;
    } on Error catch (e) {
      responseCode2 = -3;
      notifyListeners();
      print("General Error: $e");
      return false;
    }
  }

  void showCategories(int index) {
    if (lastButtonIndex == index) {
      if (index == 4) {
        _showSubCategories2 = false;
      } else {
        _showSubCategories1 = false;
      }
      lastButtonIndex = -1;
      activeIndex = -1;
      _activeCategories[index] = false;
    } else {
      activeIndex = index;
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

  bool get showSubCategories1 => _showSubCategories1;

  bool get showSubCategories2 => _showSubCategories2;

  List<bool> get activeAcategories => _activeCategories;

  bool get networkCallDone => _networkCallDone;

  set networkCallDone(bool value) {
    _networkCallDone = value;

  }

  bool get scrollControllerRegistered => _scrollControllerRegistered;
  set scrollControllerRegistered(bool value) {
    _scrollControllerRegistered = value;


  }
  void  cleanHomeScreen(){
    allPosts.clear();
    activeIndex = -1;
    _showSubCategories1 = false;
    _showSubCategories2 = false;
    responseCode1 = 0;
    responseCode2 = 0;
    categoriesMessage = "";
    _networkCallDone = false;
    for(int i = 0; i < _activeCategories.length; i++){
      _activeCategories[i] = false;
    }
    notifyListeners();

  }




}
