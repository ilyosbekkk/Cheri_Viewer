
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:viewerapp/business_logic/services/web%20services.dart';

class CheriProvider extends ChangeNotifier {

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