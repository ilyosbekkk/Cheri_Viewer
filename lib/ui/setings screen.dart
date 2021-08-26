// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen();
//
//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }
//
// class _SettingsrScreenState extends State<SettingsScreen> {
//   late InAppWebViewController _controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(child: InAppWebView(
//        // initialUrlRequest: URLRequest(url: Uri.parse(url)),
//         initialOptions: InAppWebViewGroupOptions(
//             crossPlatform: InAppWebViewOptions(
//               javaScriptEnabled: true,
//             ),
//             android: AndroidInAppWebViewOptions(
//               useHybridComposition: true,
//             ),
//             ios: IOSInAppWebViewOptions(
//               allowsInlineMediaPlayback: true,
//             )),
//       ),
//
//       ),
//     );
//   }
// }
