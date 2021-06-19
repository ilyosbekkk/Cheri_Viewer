import 'package:viewerapp/models/postslist_model.dart';
import 'package:flutter/foundation.dart';

class HomePageProvider extends ChangeNotifier {
  bool _showSubCategories1 = false;
  bool _showSubCategories2 = false;
  List<String> _subCategories = [
    "Sub1",
    "Sub2",
    "Sub3",
    "Sub4",
    "Sub5",
    "Sub6",
    "Sub7",
    "Sub8",
    "Sub9",
    "Sub10",
  ];
  int lastButtonIndex = -1;
  List<bool> _activeCategories = [false,false,false, false, false, false];

  void like(Post post) {
    print("like pressed");
    post.like = true;
    notifyListeners();
  }

  void unLike(Post post) {
    print("unlike pressed");
    post.like = false;
    notifyListeners();
  }

  void fetchSubCategories(String categoryName, int index) {
    print("fetching  categories");
    for(int  i = 0; i<_activeCategories.length; i++) {
      _activeCategories[i] = false;
    }
    if (_subCategories.length > 10) _subCategories.removeAt(10);
    _subCategories.add(categoryName);

    print(lastButtonIndex);
    if (lastButtonIndex == index) {

      if(index == 4)
        _showSubCategories2 = false;
      else
      _showSubCategories1 = false;
      lastButtonIndex = -1;
    }
    else {
      _activeCategories[index] = true;
      lastButtonIndex = index;
      if(index == 4) {
        _showSubCategories2 = true;
        _showSubCategories1 = false;
      }
      else{
    _showSubCategories1 = true;
    _showSubCategories2 = false;

      }
    }

    notifyListeners();
  }

  bool get showSubCategories1 => _showSubCategories1;
  bool get showSubCategories2 => _showSubCategories2;


  List<String> get subCategories => _subCategories;
  List<bool> get activeAcategories => _activeCategories;
}
