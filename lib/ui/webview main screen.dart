import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/providers/home%20provider.dart';
import 'package:viewerapp/providers/saved%20posts%20screen%20provider.dart';
import 'package:viewerapp/providers/user%20management%20provider.dart';
import 'package:viewerapp/ui/home_screen.dart';
import 'package:viewerapp/utils/strings.dart';
import 'package:viewerapp/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  static String route = "/profile_screen";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late InAppWebViewController _controller;
  String? language;

  @override
  Widget build(BuildContext context) {
    language = languagePreferences!.getString("language") ?? "ko";
    var provider = Provider.of<UserManagementProvider>(context, listen: true);
    var savedPostsProvider  = Provider.of<CollectionsProvider>(context, listen: true);
    var homeProvider   = Provider.of<HomeProvider>(context, listen: true);
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String?>;

    String url = args["user_id"] == null
        ? "https://cheri.weeknday.com/viewer/profile?my=${args["encrypt_id"]}"
        : "https://cheri.weeknday.com/viewer/profile?my=${args["encrypt_id"]}&m=${args["user_id"]}";
    return 
      
      
      
      WillPopScope(

        onWillPop: (){
          var future = _controller.canGoBack();
          future.then((value) {
            if(value){
              _controller.goBack();
            }
            else {
              Navigator.pop(context);
            }
          });

          return Future.value(true);

        },
        child: Scaffold(

          body:

            SafeArea(
              child: InAppWebView(
                  initialUrlRequest: URLRequest(url: Uri.parse(url)),
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        javaScriptEnabled: true,
                      ),
                      android: AndroidInAppWebViewOptions(
                        useHybridComposition: true,
                      ),
                      ios: IOSInAppWebViewOptions(
                        allowsInlineMediaPlayback: true,
                      )),
                  onWebViewCreated: (InAppWebViewController controller) {
                    setState(() {
                      _controller = controller;
                    });

                    _controller.addJavaScriptHandler(
                        handlerName: "go_main",
                        callback: (args) {
                          print(args);
                          switch (args[0]) {
                            case "go_main":
                              {
                                Navigator.pop(context);
                                break;
                              }
                            case "pw_change":
                              {
                                Navigator.pop(context);
                                showToast("${passwordChanged[language]}");
                                break;
                              }

                            case "log_out":
                              {
                                provider.logout().then((value) {
                                  if (value) {
                                    savedPostsProvider.cleanCollections();
                                    homeProvider.cleanHomeScreen();

                                    Navigator.pop(context);
                                    showToast("${logoutMessage[language]}");
                                  } else {
                                    showToast("${logoutFailure[language]}");
                                  }
                                });
                                break;
                              }
                            case "delete_account":
                              {
                                provider.logout().then((value) {
                                  if (value) {
                                    savedPostsProvider.cleanCollections();
                                    homeProvider.cleanHomeScreen();

                                    showToast("${deleteAcountMessage[language]}");
                                  } else
                                    showToast("${deleteAccountError[language]}");
                                });
                                break;
                              }
                          }
                        });
                    _controller.addJavaScriptHandler(
                        handlerName: "change_language",
                        callback: (args) {
                          provider.langChange(args[0], context);
                        });
                  }),
            ),


        ),
      );
  }
}


