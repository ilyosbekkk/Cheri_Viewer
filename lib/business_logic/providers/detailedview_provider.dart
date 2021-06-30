import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:viewerapp/business_logic/services/web_services.dart';
import 'package:viewerapp/models/detailedpost_model.dart';
import 'package:viewerapp/models/postitem_model.dart';

class DetailedViewProvider extends ChangeNotifier {
  late DetailedPost _detailedPost;
  late List<Item> _items;

  Future<bool> fetchDetailedViewData(String cheriId, memberId) async {
    Response response = await WebServices.fetchDetailedViewData(cheriId, memberId);
    Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
    DetailedPostResponse postsResponse = DetailedPostResponse.fromJson(decodedResponse);

    _detailedPost = postsResponse.detailedPosts!;
    notifyListeners();
    return true;
  }

  Future<bool> fetchDetailedViewItemsList(String cheriId, String memberId) async {
    Response response = await WebServices.fetchDetailedViewItemsList(cheriId, memberId);
    Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));

    if (_items.isNotEmpty) _items.clear();

    ItemsResponse itemsResponse = ItemsResponse.fromJson(decodedResponse);
    _items.addAll(itemsResponse.items!);
    notifyListeners();

    return true;
  }

  Future<bool> fetchDetailedViewFilesList(String cheriId) async {
    Response response = await WebServices.fetchDetailedViewFilesList(cheriId);
    Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));

    return true;
  }

  List<Item> get items => _items;

  DetailedPost get detailedPost => _detailedPost;
}
