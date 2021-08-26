import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:viewerapp/services/web%20services.dart';

import 'package:viewerapp/models/postslist_model.dart';

class CollectionsProvider extends ChangeNotifier {
  List<Post> savedPosts = [];
  List<Post> searchSavedPosts = [];
  List<Post> searchOpenedPosts = [];
  int statusCode1 = 0;
  int statusCode2 = 0;
  List<Post> openedPosts = [];
  bool isScrollControllerRegistered = false;
  bool networkCallDone = false;

  Future<bool> fetchSavedPostsList(
      String memberId, int pageSize, int nowPage, String orderBy) async {
    try {
      Response response = await WebServices.fetchBookmarkList(
          memberId, pageSize, nowPage, orderBy);
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        PostsResponse postsResponse = PostsResponse.fromJson(decodedResponse);
        savedPosts.addAll(postsResponse.data);
        statusCode1 = response.statusCode;
        notifyListeners();
        return true;
      } else {
        statusCode1 = response.statusCode;
        notifyListeners();
        return false;
      }
    } on SocketException catch (e) {
      print(e);
      statusCode1 = -2;
      notifyListeners();
      return false;
    }
  }

  Future<bool> fetchOpenedPostsList(
      String memberId, int pageSize, int nowPage, String orderBy) async {
    try {
      Response response = await WebServices.fetchOpenedCheriList(
          memberId, pageSize, nowPage, orderBy);

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse =
            json.decode(utf8.decode(response.bodyBytes));
        PostsResponse postsResponse = PostsResponse.fromJson(decodedResponse);
        print(decodedResponse);
        openedPosts.addAll(postsResponse.data);
        statusCode2 = response.statusCode;
        print("size");
        print(openedPosts.length);
        notifyListeners();
        return true;
      } else {
        print("opened");
        print(response.body);
        return false;
      }
    } on TimeoutException catch (e) {
      statusCode2 = -1;
      notifyListeners();
      return false;
    } on SocketException catch (e) {
      statusCode2 = -2;
      notifyListeners();
      return false;
    } on Error catch (e) {
      print(e);
      statusCode2 = -3;
      notifyListeners();
      return false;
    }
  }

  void searchSaved(String searchWord) {
    if (searchSavedPosts.isNotEmpty) searchSavedPosts.clear();
    for (int i = 0; i < savedPosts.length; i++) {
      if (savedPosts[i].title.contains(searchWord) && searchWord.isNotEmpty)
        searchSavedPosts.add(savedPosts[i]);
    }

    notifyListeners();
  }

  void searchOpened(String searchWord) {
    if (searchOpenedPosts.isNotEmpty) searchOpenedPosts.clear();
    for (int i = 0; i < openedPosts.length; i++) {
      if (openedPosts[i].title.contains(searchWord) && searchWord.isNotEmpty)
        searchOpenedPosts.add(openedPosts[i]);
    }
    notifyListeners();
  }

  void cleanCollections() {
    savedPosts.clear();
    openedPosts.clear();
    statusCode1 = 0;
    searchSavedPosts.clear();
    searchOpenedPosts.clear();
    statusCode2 = 0;
    isScrollControllerRegistered = false;
    networkCallDone = false;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}
