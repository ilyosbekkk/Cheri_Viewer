import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/business_logic/providers/user management provider.dart';
import 'package:viewerapp/utils/utils.dart';

class AuthScreen extends StatefulWidget {
  static String route = "/auth_screen";

  AuthScreen();

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late InAppWebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<UserManagementProvider>(builder: (context, authProvider, child) {
          return Container(
            child: InAppWebView(

              initialUrlRequest: URLRequest(url: Uri.parse("https://cheri.weeknday.com/viewerlogin")),

              initialOptions: InAppWebViewGroupOptions(

                crossPlatform: InAppWebViewOptions(
                  javaScriptCanOpenWindowsAutomatically: true,
                  userAgent: 'random',
                  javaScriptEnabled: true,
                  useShouldOverrideUrlLoading: true,
                  mediaPlaybackRequiresUserGesture: false,
                ),
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                ),
                  ios: IOSInAppWebViewOptions(
                    allowsInlineMediaPlayback: true,
                    enableViewportScale: true
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
                      authProvider.saveUserData(args[0]["ID"], args[0]["EMAIL"], args[0]["PICTURE"], args[0]["NAME"], args[0]["encrypt_id"]).then((value) {
                        if (value == true) {
                          Navigator.pop(context);
                          showToast("구글 로그인이 성공 되었습니다");
                        } else
                          showToast("구글 로그인이 실패 되었습니다");
                      });
                    });
                _controller.addJavaScriptHandler(
                    handlerName: "kakao",
                    callback: (args) async {
                      return await authProvider.signInWithKakao();
                    });
                _controller.addJavaScriptHandler(
                    handlerName: "kakao_user_info",
                    callback: (args) {
                      print("kakao info: $args");
                    });
                _controller.addJavaScriptHandler(
                    handlerName: "naver",
                    callback: (args) async {
                      return await authProvider.signInWithNaver();
                    });
                _controller.addJavaScriptHandler(
                    handlerName: "naver_user_info",
                    callback: (args) {
                      print("naver info: $args");
                    });
                _controller.addJavaScriptHandler(handlerName: "email", callback: (args) {});
              },
            ),
          );
        }),
      ),
    );
  }
}
