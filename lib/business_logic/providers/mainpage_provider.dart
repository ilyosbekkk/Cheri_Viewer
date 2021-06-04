import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:viewerapp/models/post_model.dart';

class MainPageProvider extends ChangeNotifier {
  Future<List<Post>> fetchPostsList() async {
    http.Response response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {




    }
  }
}