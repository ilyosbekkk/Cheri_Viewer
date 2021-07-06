

import 'package:flutter/foundation.dart';
import 'package:viewerapp/models/postslist_model.dart';

class CollectionsProvider extends ChangeNotifier{
  List<Post> bookMarkedPosts = [];

  Future<bool> fetchSavedPostsList() async {
    return true;
  }

  Future<bool> fetchOpenedPostsList() async {
    return true;
  }

}