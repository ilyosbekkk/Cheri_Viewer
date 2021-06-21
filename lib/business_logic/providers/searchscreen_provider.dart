
import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:viewerapp/models/postslist_model.dart';

import '../services/web_services.dart';

class SearchScreenProvider extends ChangeNotifier {


  late  List<Post> searchResults = [];
  String responseCode = "";
  String message = "";

  Future<bool> searchPostByTitle(int pageSize, int nowPage,  String  orderBy, String searchWord) async {
    try {
      Response response =  await WebServices.searchPostByTitle(pageSize, nowPage, orderBy, searchWord);

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        PostsResponse postsResponse = PostsResponse.fromJson(decodedResponse);
        responseCode = postsResponse.code;
        message = postsResponse.message;
        searchResults.addAll(postsResponse.data);
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

}