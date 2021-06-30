import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:viewerapp/business_logic/services/web_services.dart';

class DetailedViewProvider extends ChangeNotifier {
  Future<bool> fetchDetailedViewData(String cheriId, memberId) async {
    Response response = await WebServices.fetchDetailedViewData(cheriId, memberId);
    print(response.body);

    return true;
  }

  Future<bool> fetchDetailedViewItemsList(String cheriId) async {
    Response response = await WebServices.fetchDetailedViewItemsList(cheriId);
    print(response.body);

    return true;
  }

  Future<bool> fetchDetailedViewFilesList(String cheriId, memberId) async {
    Response response = await WebServices.fetchDetailedViewFilesList(cheriId);
    print(response.body);

    return true;
  }
}
