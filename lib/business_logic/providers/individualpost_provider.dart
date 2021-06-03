import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/post_model.dart';

class PostProvider extends ChangeNotifier {

  void like(Post post)  {
    
    print("like pressed");
    post.like = true;
    notifyListeners();
  }
  void unLike(Post post)  {
    print("unlike pressed");
    post.like = false;
    notifyListeners();
  }




}
