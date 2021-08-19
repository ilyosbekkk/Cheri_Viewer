
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:viewerapp/services/web%20services.dart';

class CheriProvider extends ChangeNotifier {

  Future<bool> saveCheriPost(String? cheriId, String state, String memberId) async {
    try {
      print(cheriId);
      print(memberId);
      print(state);
      Response response = await WebServices.saveCheriPost(cheriId!, memberId, state);
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


}