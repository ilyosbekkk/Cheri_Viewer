import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:viewerapp/utils/strings.dart';

class WebServices {
  static Map<String, String> headers = {'Accept': 'application/json;'};

  static Future<http.Response> fetchPosts(int pageSize, int nowPage, String orderBy, int category, String  memberId) async {
    print("hello  world $memberId");
    final url = Uri.https(baseUrl, postsList);
    late  Map<String, String> body;
    if(memberId.isNotEmpty)
     body = {'pagesize': '$pageSize', 'nowpage': '$nowPage', 'orderby': '$orderBy', 'category': '$category', "member_id": memberId};
    else
       body  = {'pagesize': '$pageSize', 'nowpage': '$nowPage', 'orderby': '$orderBy', 'category': '$category'};
    http.Response response = await http.post(url, headers: headers, body: body);
    return response;
  }

  static Future<http.Response> searchPostByTitle(int pageSize, int nowPage, String orderBy, String searchWord, String memberId) async {
    final url = Uri.https(baseUrl, searchPost);
    final body = {'pagesize': '$pageSize', 'nowpage': '$nowPage', 'orderby': '$orderBy', 'search_word': '$searchWord', 'member_id': '$memberId', 'category': '0'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchCategoriesList(String site_id) async {
    final url = Uri.https(baseUrl, categoryList);
    final body = {'site_id': '$site_id'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchDetailedViewData(String cheriId, String memberId) async {

    final url = Uri.https(baseUrl, detailedDataList);
    final body = {'cheri_id': '$cheriId', 'member_id': '$memberId'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> updateCheckListItem(String itemId, String checked, String memberId,  String cheriId) async {
    final url = Uri.https(baseUrl, checkUpdate);
    final body = {'cheri_item_id': itemId, 'checked': checked, 'member_id': memberId, 'cheri_id': cheriId};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> saveCheriPost(String cheriId, String memberId, String state) async {
    final url = Uri.https(baseUrl, savePost);
    final body = {'cheri_id': cheriId, 'state': state, 'member_id': memberId};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchRecentSearches(String memberId) async {
    print("memberId: $memberId");
    final url = Uri.https(baseUrl, recentSearches);
    final body = {'member_id': memberId};
    http.Response response = await http.post(url, headers: headers, body: body);

    print("body: ${response.body}");

    return response;
  }

  static Future<http.Response> fetchRelatedSearches( String searchWord) async {
    final url = Uri.https(baseUrl, relatedSearches);
    final body = {'search_word': searchWord};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchBookmarkList(String memberId, int  pageSize, int  nowPage, String orderBy) async {
    final url = Uri.https(baseUrl, bookMarkList);
    final body = {'member_id': memberId, 'pagesize': pageSize.toString(), 'nowpage' :nowPage.toString(), 'orderby':orderBy};

    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchOpenedCheriList(String memberId, int  pageSize, int  nowPage, String orderBy) async {
    final url = Uri.https(baseUrl,openCheriList);
    final body = {'member_id': memberId, 'pagesize': pageSize.toString(), 'nowpage' :nowPage.toString(), 'orderby':orderBy};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchDeviceVersion() async {
    String os = "idle";
    final url = Uri.https(baseUrl, fetchDeviceLatestVersion);
    if(Platform.isAndroid)
      os = "android";
    else if (Platform.isIOS)
      os = "ios";
    final body = {'os': os, 'app_name': 'cheri_viewer'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

}
