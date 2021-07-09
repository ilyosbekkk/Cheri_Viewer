import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:viewerapp/business_logic/services/web%20services.dart';
import 'package:viewerapp/models/postslist_model.dart';

class CollectionsProvider extends ChangeNotifier {
  List<Post> savedPosts = [];
  String _sMessage = "";
  List<Post> openedPosts = [];
  String _oMessage = "";

  Future<bool> fetchSavedPostsList(String memberId, String pageSize, String nowPage, String orderBy) async {
    try {
      Response response = await WebServices.fetchBookmarkList(memberId, pageSize, nowPage, orderBy);

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        PostsResponse postsResponse = PostsResponse.fromJson(decodedResponse);
        print("bookmark post list");
        print(decodedResponse);
        _sMessage = postsResponse.message;
        print(_sMessage);
        savedPosts.addAll(postsResponse.data);
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

  Future<bool> fetchOpenedPostsList(String memberId, String pageSize, String nowPage, String orderBy) async {
    try {
      Response response = await WebServices.fetchOpenedCheriList(memberId, pageSize, nowPage, orderBy);

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        PostsResponse postsResponse = PostsResponse.fromJson(decodedResponse);
        print("opened post list");
        print(decodedResponse);
        _oMessage = postsResponse.message;
        print(_oMessage);
        openedPosts.addAll(postsResponse.data);
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

  String get oMessage => _oMessage;

  String get sMessage => _sMessage;
}
