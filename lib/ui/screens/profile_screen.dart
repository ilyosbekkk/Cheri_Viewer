

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:viewerapp/utils/utils.dart';


class ProfileScreen extends StatefulWidget {
  static String route = "/profile_screen";

  const ProfileScreen();

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late InAppWebViewController _controller;


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
                  initialUrlRequest: URLRequest(url: Uri.parse("https://cheri.weeknday.com/viewer/profile?my=${args["encrypt_id"]}")),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      javaScriptEnabled: true,
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

                    _controller.addJavaScriptHandler(handlerName: "go_main", callback: (args) {
                      Navigator.pop(context);
                      showToast("비밀번호 changed!");

                    });

                  }),
      ),

    );
  }


}
