import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:viewerapp/models/postslist_model.dart';

class WebServices {
  //fetch all posts
  static Future<http.Response> fetchPosts(int pageSize, int nowPage,  String orderBy,  int category) async {

    final  url =  Uri.https("cheri.weeknday.com", "/api/native/list" );
    final body = {'pagesize': '$pageSize','nowpage': '$nowPage','orderby':'$orderBy','category': '$category'};
    Map<String,  String> headers = {'Accept':'application/json;'};

    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

}
