import 'package:http/http.dart' as http;
import 'package:viewerapp/utils/strings.dart';

class WebServices {


  static Future<http.Response> fetchPosts(int pageSize, int nowPage, String orderBy, int category) async {
    final url = Uri.https(baseUrl, postsList);
    final body = {'pagesize': '$pageSize', 'nowpage': '$nowPage', 'orderby': '$orderBy', 'category': '$category'};
    Map<String, String> headers = {'Accept': 'application/json;'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> searchPostByTitle(int pageSize, int nowPage, String orderBy, String searchWord) async {
    final url = Uri.https(baseUrl, searchPost);
    final body = {'pagesize': '$pageSize', 'nowpage': '$nowPage', 'orderby': '$orderBy', 'search_word': '$searchWord'};
    Map<String, String> headers = {'Accept': 'application/json;'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchCategoriesList(String site_id) async {
    final url = Uri.https(baseUrl, categoryList);
    final body = {'site_id': '${site_id}'};
    Map<String, String> headers = {'Accept': 'application/json;'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchDetailedViewData(String cheri_id,  String member_id) async {
    final url = Uri.https(baseUrl, detailedDataList);
    final body = {'cheri_id': '$cheri_id', 'member_id': '$member_id'};
    Map<String, String> headers = {'Accept': 'application/json;'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchDetailedViewItemsList(String cheri_id) async {
    final url = Uri.https(baseUrl, detailedViewItemList);
    final body = {'cheri_id': '${cheri_id}'};
    Map<String, String> headers = {'Accept': 'application/json;'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> fetchDetailedViewFilesList(String cheri_id) async {
    final url = Uri.https(baseUrl, detailedViewFileList);
    final body = {'cheri_id': '${cheri_id}'};
    Map<String, String> headers = {'Accept': 'application/json;'};
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }
}
