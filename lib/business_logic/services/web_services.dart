import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class WebServices {
  //fetch all posts
  static Future<void> fetchPosts() async {

    String url = "https://cheri.weeknday.com/api/native/search";
    final body = {"pagesize": "8","nowpage": "1","orderby":"views","searchword": "cheri"};
    Map<String,  String> headers = {'Content-Type':'application/json; charset=UTF-8','Accept':'application/json'};
    String jsonbody = json.encode(body);

    /*
   1) Url - *
   2) headers = ?
   3) body = ??
   */
    http.Response response = await http.post(Uri.parse(url), headers: headers, body: jsonbody);
    print(response.body);
  }
}
