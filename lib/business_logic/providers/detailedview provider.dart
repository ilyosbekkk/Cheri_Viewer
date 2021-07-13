import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:viewerapp/business_logic/services/web services.dart';
import 'package:viewerapp/models/detailedpost_model.dart';

class DetailedViewProvider extends ChangeNotifier {
  late Intro _detailedPost;
  List<Item> _items = [];
  List<File> _files = [];
  late DetailedPostResponse postsResponse;

  late bool _loaded;

  Future<bool> fetchDetailedViewData(String cheriId, memberId) async {
    _loaded = false;
    try {
      _detailedPost = Intro();
      if (_items.isNotEmpty) _items.clear();
      if (_files.isNotEmpty) _files.clear();

      Response response = await WebServices.fetchDetailedViewData(cheriId, memberId);
      Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
      postsResponse = DetailedPostResponse.fromJson(decodedResponse);
      print(decodedResponse);
      if (postsResponse.msg == "success") {
        _loaded = true;
        _detailedPost = postsResponse.detailedPosts!;
        _items.addAll(postsResponse.items);
        _files.addAll(postsResponse.files);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateCheckListItem(String itemId, String checked, String memberId) async {
    try {
      Response response = await WebServices.updateCheckListItem(itemId, checked, memberId);
      if (response.statusCode == 200) {

        print(response.body);
        return true;
      } else
        return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> saveCheriPost(String? cheriId, String state, String memberId) async {
    try {
      Response response = await WebServices.saveCheriPost(cheriId!, memberId, state);
      if (response.statusCode == 200) {
        return true;
      } else
        return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
  


  List<Item> get items => _items ;

  List<File>  itemFiles(String itemId) {
     List<File> files = [];
     
     for(int i = 0; i<_files.length; i++) {
       if(_files[i].itemId == itemId) {
         files.add(_files[i]);

       }
     }
     return files;
  }

  Intro get detailedPost => _detailedPost;

  bool get loaded => _loaded;
}
