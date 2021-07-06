import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:viewerapp/utils/utils.dart';

class UserManagementProvider extends ChangeNotifier {
  //google signin
  Future<Map<String, String>> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = (await GoogleSignIn().signIn())!;
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);


    Map<String, String> credentials = {"access_token": "${googleAuth.accessToken}", "id_token": " ${googleAuth.idToken}", "site_id": "${googleUser.id}", "email": "${googleUser.email}", "name": "${googleUser.displayName}"};

    return credentials;
  }

  //kakao auth
  Future<String> signInWithKakao() async {
    final installed = await isKakaoTalkInstalled();
    String credentials;
    KakaoContext.clientId = "818a2baccb86e7432dcdb89f7957110d";
    if (installed) {
      try {
        var code = await AuthCodeClient.instance.request();
        var token = await AuthApi.instance.issueAccessToken(code);
        AccessTokenStore.instance.toStore(token);
        credentials = "access_token:${token.accessToken}";
      } on KakaoAuthException catch (e) {
        showToast("Unexpected error occured, please try again!");
        print(e);
        credentials = e.toString();
      } on KakaoClientException catch (e) {
        showToast("Unexpected error occured, please try again!");
        print(e);
        credentials = e.toString();
      }
    } else {
      showToast("Kakao talk is not installed");
      credentials = "?";
    }
    return credentials;
  }

  //naver auth
  Future<String> signInWithNaver() async {
    String credentials;
    NaverLoginResult res = await FlutterNaverLogin.logIn();
    NaverAccessToken naverAccessToken = await FlutterNaverLogin.currentAccessToken;
    credentials = "access_token:${naverAccessToken}";
    return credentials;
  }

  Future<bool> saveUserData(String id,  String email, String  imgUrl,  String name,  String encryptedId) async {
    bool setId = await preferences!.setString("id", id);
    bool setEmail = await preferences!.setString("email", email);
    bool setImgUrl = await preferences!.setString("imgUrl", imgUrl);
    bool setName = await preferences!.setString("name", name);
    bool  setEncryptedId = await  preferences!.setString("encrypt_id", encryptedId);

    if (setId && setEmail && setImgUrl && setName && setEncryptedId  ) {
      print("Hey I've done");
      return true;
    }
    return false;
  }

  Future<bool> logout() async {
    return await preferences!.clear();
  }
}
