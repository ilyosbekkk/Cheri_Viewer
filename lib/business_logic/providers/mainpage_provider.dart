import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:viewerapp/business_logic/services/web_services.dart';
import 'package:viewerapp/models/post_model.dart';

class MainPageProvider extends ChangeNotifier {
  List<Post> posts = [];

  Future<List<Post>> fetchPostsList() async {
    await WebServices.fetchPosts();
    return posts;
  }
}
