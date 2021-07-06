import 'package:http/http.dart' as http;
import 'package:viewerapp/utils/strings.dart';

class WebServices {
  static Map<String, String> headers = {'Accept': 'application/json;'};

  static Future<http.Response> fetchPosts(int pageSize, int nowPage, String orderBy, int category) async {
    final url = Uri.http(baseUrl, postsList);
    final body = {'pagesize': '$pageSize', 'nowpage': '$nowPage', 'orderby': '$orderBy', 'category': '$category'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> searchPostByTitle(int pageSize, int nowPage, String orderBy, String searchWord, String memberId) async {
    final url = Uri.http(baseUrl, searchPost);
    final body = {'pagesize': '$pageSize', 'nowpage': '$nowPage', 'orderby': '$orderBy', 'search_word': '$searchWord', 'member_id' :'$memberId', 'category' : '0'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchCategoriesList(String site_id) async {
    final url = Uri.http(baseUrl, categoryList);
    final body = {'site_id': '$site_id'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchDetailedViewData(String cheriId, String memberId) async {
    final url = Uri.http(baseUrl, detailedDataList);
    final body = {'cheri_id': '$cheriId', 'member_id': '$memberId'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> updateCheckListItem(String itemId, String checked, String memberId) async {
    final url = Uri.http(baseUrl, checkUpdate);
    final body = {'cheri_item_id': itemId, 'checked': checked, 'member_id': memberId};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> saveCheriPost(String cheriId, String memberId, String state) async {
    final url = Uri.http(baseUrl, savePost);
    final body = {'cheri_id': cheriId, 'state': state, 'member_id': memberId};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchRecentSearches(String memberId) async {
    final url = Uri.http(baseUrl, recentSearches);
    final body = {'member_id': memberId};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchRelatedSearches(String memberId, String searchWord) async {
    final url = Uri.http(baseUrl, relatedSearches);
    final body = {'member_id': memberId, 'search_word': searchWord};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }
}
