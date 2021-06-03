import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:viewerapp/utils/utils.dart';

class AuthProvider extends ChangeNotifier {
  Future<String> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
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

  Future<String> signInWithKakao() async {
    final installed = await isKakaoTalkInstalled();

    if (installed) {
      var code = await AuthCodeClient.instance.request();
      var token = await AuthApi.instance.issueAccessToken(code);
      AccessTokenStore.instance.toStore(token);
      var user = await UserApi.instance.me();

      String credentials = "access_token:${token.accessToken}, id_token:${token.refreshToken}, access_token_experis_in:${token.expiresIn}, refresh_token_expires_in:${token.refreshTokenExpiresIn}, name:${user.kakaoAccount.legalName}";

      notifyListeners();
      return credentials;
    } else {
      showToast("Kakao talk is not installed");
    }
  }

  Future<String> signInWithNaver() async {


  }

  Future<String> signInWithEmail() async {}
}
