import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:viewerapp/business_logic/services/web%20services.dart';
import 'package:viewerapp/models/postslist_model.dart';

class CollectionsProvider extends ChangeNotifier {
  List<Post> savedPosts = [];
  int statusCode1 = 0;
  int statusCode2 = 0;
  List<Post> openedPosts = [];

  Future<bool> fetchSavedPostsList(String memberId, String pageSize, String nowPage, String orderBy) async {
    try {
      Response response = await WebServices.fetchBookmarkList(memberId, pageSize, nowPage, orderBy);

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        PostsResponse postsResponse = PostsResponse.fromJson(decodedResponse);
        print("response1:");
        print(decodedResponse);
        savedPosts.addAll(postsResponse.data);
        statusCode1 = response.statusCode;
        notifyListeners();
        return true;
      } else {
        statusCode1 = response.statusCode;
        notifyListeners();
        return false;
      }
    } on TimeoutException catch (e) {
      statusCode1 = -1;
      notifyListeners();
      return false;
    } on SocketException catch (e) {
      statusCode1 = -2;
      notifyListeners();
      return false;
    } on Error catch (e) {
      statusCode1 = -3;
      notifyListeners();
      return false;
    }
  }

  Future<bool> fetchOpenedPostsList(String memberId, String pageSize, String nowPage, String orderBy) async {
    try {
      Response response = await WebServices.fetchOpenedCheriList(memberId, pageSize, nowPage, orderBy);

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
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
      statusCode2 = -3;
      notifyListeners();
      return false;
    }
  }
}
