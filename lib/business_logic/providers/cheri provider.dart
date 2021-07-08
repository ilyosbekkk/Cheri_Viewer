
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:viewerapp/business_logic/services/web%20services.dart';
import 'package:viewerapp/models/postslist_model.dart';

class CheriProvider extends ChangeNotifier {

  Future<bool> save(Post post) async {
    return true;
  }

  Future<bool> unsave(Post  post ) async {
    return true;
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


}