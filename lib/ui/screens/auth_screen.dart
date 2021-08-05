import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/business_logic/providers/user management provider.dart';
import 'package:viewerapp/utils/strings.dart';
import 'package:viewerapp/utils/utils.dart';

class AuthScreen extends StatefulWidget {
  static String route = "/auth_screen";

  AuthScreen();

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late InAppWebViewController _controller;
  String? language;

  @override
  Widget build(BuildContext context) {
    language = languagePreferences!.getString("language")??"kr";
    return Scaffold(
      body: SafeArea(
        child: Consumer<UserManagementProvider>(builder: (context, authProvider, child) {
          return InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse("https://cheri.weeknday.com/viewer/login")),
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptCanOpenWindowsAutomatically: true,
                  userAgent:  'random',
                  javaScriptEnabled: true,
                  useShouldOverrideUrlLoading: true,
                  mediaPlaybackRequiresUserGesture: false,
                ),
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                ),
                ios: IOSInAppWebViewOptions(
                  allowsInlineMediaPlayback: true,

                )

            ),

            onWebViewCreated: (InAppWebViewController controller) {
              setState(() {
                _controller = controller;
              });
              _controller.addJavaScriptHandler(
                  handlerName: "google",
                  callback: (args) async {
                    return await authProvider.signInWithGoogle();
                  });
              _controller.addJavaScriptHandler(
                  handlerName: "google_user_info",
                  callback: (args) {
                    print("args:$args");
                    if(args[0]["message"] == null){
                      authProvider.saveUserData(args[0]["ID"], args[0]["EMAIL"], args[0]["PICTURE"], args[0]["NAME"], args[0]["encrypt_id"]).then((value) {
                        if (value == true) {
                          Navigator.pop(context);
                          showToast("${googleLoginSuccess[language]}");
                        } else
                          showToast("${googleLoginSuccessFailure[language]}");
                      });}
                    else  {
                      showToast(args[0]["message"]);
                    }
                  });
              _controller.addJavaScriptHandler(
                  handlerName: "kakao",
                  callback: (args) async {
                    return await authProvider.signInWithKakao();
                  });
              _controller.addJavaScriptHandler(
                  handlerName: "kakao_user_info",
                  callback: (args) {
                    print(args);
                    if(args[0]["message"] == null){
                      authProvider.saveUserData(args[0]["ID"], args[0]["EMAIL"], args[0]["PICTURE"], args[0]["NAME"], args[0]["encrypt_id"]).then((value) {
                        if (value == true) {
                          Navigator.pop(context);
                          showToast("${kakaoLoginSuccess[language]}");
                        } else
                          showToast("${kakaoLoginSuccessFailure[language]}");

                      });}
                    else {
                      showToast(args[0]["message"]);
                    }
                  });

              _controller.addJavaScriptHandler(handlerName: "naver_user_info", callback: (args) {
                  authProvider.saveUserData(args[0]["ID"], args[0]["EMAIL"], args[0]["PICTURE"], args[0]["NAME"], args[0]["encrypt_id"]).then((value) {
                    if(value)
                      Navigator.pop(context);
                    else showToast("Unexpected error happened, Please  try again");
                  });

              });
              _controller.addJavaScriptHandler(
                  handlerName: "naver", callback: (args) async{
                return await authProvider.signInWithNaver();
              });

              _controller.addJavaScriptHandler(handlerName: "email_user_info", callback: (args) {
                print("$args");

                authProvider.saveUserData(
                    args[0]["ID"], args[0]["EMAIL"], args[0]["PICTURE"],
                    args[0]["NAME"], args[0]["encrypt_id"]).then((value) {
                  if (value == true) {
                    Navigator.pop(context);
                    showToast("${emailLoginSuccess[language]}");
                  } else
                    showToast("${emailLoginSuccessFailure[language]}");
                });
              });
              _controller.addJavaScriptHandler(handlerName: "go_main", callback: (args) {
                print(args);
                Navigator.pop(context);
              });

            },
          );

        }),
      ),
    );
  }
}

