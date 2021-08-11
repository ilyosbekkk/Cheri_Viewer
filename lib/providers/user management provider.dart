

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart';

import 'package:viewerapp/utils/utils.dart';

class UserManagementProvider extends ChangeNotifier {


  String? userId;
  String? userEmail;
  String? imgUrl;
  String? name;
  String? encryptedId;

  Future<Map<String, String>> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = (await GoogleSignIn().signIn())!;
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);

    Map<String, String> credentials = {"access_token": "${googleAuth.accessToken}", "id_token": " ${googleAuth.idToken}", "site_id": "${googleUser.id}", "email": "${googleUser.email}", "name": "${googleUser.displayName}", "picture": "${googleUser.photoUrl}"};

    return credentials;
  }

  Future<Map<String,  String>?> signInWithKakao() async {
    KakaoContext.clientId = "818a2baccb86e7432dcdb89f7957110d";
    final installed = await isKakaoTalkInstalled();
    String? authCode;
    Map<String,String>? credentials;
    try {
      if(installed)
          authCode = await AuthCodeClient.instance.requestWithTalk();
        else
          authCode = await AuthCodeClient.instance.request();

        AccessTokenResponse  accessTokenResponse = await AuthApi.instance.issueAccessToken(authCode);

         AccessTokenStore.instance.toStore(accessTokenResponse);
        var user = await UserApi.instance.me();
        String accessToken = accessTokenResponse.accessToken;
        String  refreshToken = accessTokenResponse.refreshToken.toString();
        String siteId = user.id.toString();
        String email = user.kakaoAccount!.email??"";
        String name = user.kakaoAccount!.legalName??"";
        String photoUrl = user.kakaoAccount!.profile!.profileImageUrl??"";


       credentials = {"access_token": accessToken, "id_token": refreshToken, "site_id": siteId, "email": email,  "name":name , "picture": photoUrl};
       return credentials;
       }
       on KakaoAuthException catch (e) {
        showToast("Unexpected error occured, please try again!");
        print(e);
        return  {"error": e.toString()};
      } on KakaoClientException catch (e) {
        showToast("Unexpected error occured, please try again!");
        print(e);
        return {"error": e.toString()};
      }
  }

  Future<Map<String,String>> signInWithNaver() async {

    NaverLoginResult res = await FlutterNaverLogin.logIn();
    print(res);
    final naverAccessToken = await FlutterNaverLogin.currentAccessToken;
    String accessToken = naverAccessToken.accessToken;
    return {"access_token": accessToken};
  }

  Future<bool> saveUserData(String? id,  String? email, String?  imgUrl,  String? name,  String? encryptedId) async {
    if(id != null &&  email  != null && imgUrl != null &&   name != null &&  name  != null && encryptedId != null) {
      bool setId = await userPreferences!.setString("id", id);
      bool setEmail = await userPreferences!.setString("email", email);
      bool setImgUrl = await userPreferences!.setString("imgUrl", imgUrl);
      bool setName = await userPreferences!.setString("name", name);
      bool setEncryptedId = await userPreferences!.setString("encrypt_id", encryptedId);

      if (setId && setEmail && setImgUrl && setName && setEncryptedId) {
        setUserCredentials();
        return true;
      }
    }
    return false;
  }

  void setUserCredentials(){
    userId =  userPreferences!.getString("id");
    userEmail = userPreferences!.getString("email");
    imgUrl = userPreferences!.getString("imgUrl");
    name = userPreferences!.getString("name");
    encryptedId = userPreferences!.getString("encrypt_id");
    notifyListeners();
  }

  Future<bool> logout() async {
    bool  isDelete =  await userPreferences!.clear();

    if(isDelete){
      userId =  userPreferences!.getString("id");
      userEmail = userPreferences!.getString("email");
      imgUrl = userPreferences!.getString("imgUrl");
      name = userPreferences!.getString("name");
      encryptedId = userPreferences!.getString("encrypt_id");
      notifyListeners();
    }


    return isDelete;
  }

  Future<bool> langChange(String newLang) async {
    bool langchange = await languagePreferences!.setString("language",newLang);
    notifyListeners();
   return  langchange;
  }
}

