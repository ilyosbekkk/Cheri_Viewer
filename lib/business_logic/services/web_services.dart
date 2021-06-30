import 'package:http/http.dart' as http;
import 'package:viewerapp/utils/strings.dart';

class WebServices {
  static Map<String,  String> headers = {'Accept': 'application/json;'};
  static Future<http.Response> fetchPosts(int pageSize, int nowPage, String orderBy, int category) async {
    final url = Uri.https(baseUrl, postsList);
    final body = {'pagesize': '$pageSize', 'nowpage': '$nowPage', 'orderby': '$orderBy', 'category': '$category'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> searchPostByTitle(int pageSize, int nowPage, String orderBy, String searchWord) async {
    final url = Uri.https(baseUrl, searchPost);
    final body = {'pagesize': '$pageSize', 'nowpage': '$nowPage', 'orderby': '$orderBy', 'search_word': '$searchWord'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchCategoriesList(String site_id) async {
    final url = Uri.https(baseUrl, categoryList);
    final body = {'site_id': '${site_id}'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchDetailedViewData(String cheriId, String member_id) async {
    final url = Uri.https(baseUrl, detailedDataList);
    final body = {'cheri_id': '$cheriId', 'member_id': '$member_id'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchDetailedViewItemsList(String cheriId, String memberId) async {
    final url = Uri.https(baseUrl, detailedViewItemList);
    final body = {'cheri_id': '${cheriId}', 'member_id': memberId};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchDetailedViewFilesList(String cheriId) async {
    final url = Uri.https(baseUrl, detailedViewFileList);
    final body = {'cheri_id': '$cheriId'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }
}
