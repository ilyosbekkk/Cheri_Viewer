import 'dart:convert';

import 'package:http/http.dart' as http;

class WebServices {
  //fetch all posts
  static Future<bool> fetchPosts() async {

    print("helllooo");
    String url = "https://cheri.weeknday.com/api/native/search";
    final body = {"pagesize": "8","nowpage": "2","orderby":"views","searchword": "cheri"};
    Map<String,  String> headers = {'Content-Type':'application/json; charset=UTF-8','Accept':'application/json'};
    String jsonbody = json.encode(body);


    http.Response response = await http.post(Uri.parse(url), headers: headers, body: jsonbody);
    print(response.body);
    return true;
  }
}
