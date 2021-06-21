import 'package:http/http.dart' as http;
import '../../utils/Strings.dart';


class WebServices {

  static Future<http.Response> fetchPosts(int pageSize, int nowPage,  String orderBy,  int category) async {

    final  url =  Uri.https(baseUrl, postsList);
    final body = {'pagesize': '$pageSize','nowpage': '$nowPage','orderby':'$orderBy','category': '$category'};
    Map<String,  String> headers = {'Accept':'application/json;'};

    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> searchPostByTitle(int pageSize, int nowPage,  String orderBy,  String   searchWord) async{
    final  url = Uri.https(baseUrl, searchPost);
    final body = {'pagesize': '$pageSize','nowpage': '$nowPage','orderby':'$orderBy','search_word': '$searchWord'};
    Map<String,  String> headers = {'Accept':'application/json;'};

    http.Response response = await http.post(url, headers: headers, body: body);
    return response;

  }

}
