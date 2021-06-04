import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:viewerapp/utils/utils.dart';

class AuthProvider extends ChangeNotifier {
  //google signin
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);

    String credentials =
        "{access_token:${googleAuth.accessToken},id_token: ${googleAuth.idToken.toString()}}";
    notifyListeners();
    return credentials;
  }

  //kakao auth
  Future<String> signInWithKakao() async {
    final installed = await isKakaoTalkInstalled();
    String credentials;
    KakaoContext.clientId = "818a2baccb86e7432dcdb89f7957110d";
    if (installed) {
      try {
        print("I am here");
        var code = await AuthCodeClient.instance.request();
        print("Code $code");
        var token = await AuthApi.instance.issueAccessToken(code);
        AccessTokenStore.instance.toStore(token);
        var user = await UserApi.instance.me();
        credentials =
            "access_token:${token.accessToken}, id_token:${token.refreshToken}, access_token_experis_in:${token.expiresIn}, refresh_token_expires_in:${token.refreshTokenExpiresIn}, name:${user.kakaoAccount.legalName}";
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
      credentials = null;
    }

    notifyListeners();
    return credentials;
  }

  //naver auth
  Future<String> signInWithNaver() async {
    String credentials;
    NaverLoginResult res = await FlutterNaverLogin.logIn();
    NaverAccessToken naverAccessToken =
        await FlutterNaverLogin.currentAccessToken;
    credentials = "access_token:${naverAccessToken}, res:${res}";
    notifyListeners();
    return credentials;
  }

  Future<String> signInWithEmail() async {}
}
