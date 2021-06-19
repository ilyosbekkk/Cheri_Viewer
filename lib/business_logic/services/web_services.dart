import 'dart:convert';

import 'package:http/http.dart' as http;

class WebServices {
  //fetch all posts
  static Future<Map<String,  dynamic>> fetchPosts() async {

    print("helllooo");
    final  url =  Uri.https("cheri.weeknday.com", "/api/native/list" );
    final body = {'pagesize': '8','nowpage': '2','orderby':'views','category': '0'};
    Map<String,  String> headers = {'Accept':'application/json;'};

    http.Response response = await http.post(url, headers: headers, body: body);
    Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));


    return decodedResponse;
  }

}
