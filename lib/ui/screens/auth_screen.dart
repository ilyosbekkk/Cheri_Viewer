import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/business_logic/providers/auth_provider.dart';

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
    var auth_provider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse("https://cheri.weeknday.com/login")),
            // initialData: InAppWebViewInitialData(data: initial_data),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
              ),
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
              ),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              setState(() {
                _controller = controller;
              });
              _controller.addJavaScriptHandler(
                  handlerName: "google",
                  callback: (args) async {
                    return await auth_provider.signInWithGoogle();
                  });
              _controller.addJavaScriptHandler(
                  handlerName: "google_user_info",
                  callback: (args) {
                    print("ewferofgr");
                    print("google info: $args");
                  });
              _controller.addJavaScriptHandler(
                  handlerName: "kakao",
                  callback: (args) async {
                    return await auth_provider.signInWithKakao();
                  });
              _controller.addJavaScriptHandler(
                  handlerName: "kakao_user_info",
                  callback: (args) {
                    print("kakao info: $args");
                  });
              _controller.addJavaScriptHandler(
                  handlerName: "naver",
                  callback: (args) async {
                    return await auth_provider.signInWithNaver();
                  });
              _controller.addJavaScriptHandler(
                  handlerName: "naver_user_info",
                  callback: (args) {
                    print("naver info: $args");
                  });
              _controller.addJavaScriptHandler(
                  handlerName: "email", callback: (args) {});
            },
          ),
        ),
      ),
    );
  }
}
