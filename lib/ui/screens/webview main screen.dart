import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/business_logic/providers/user%20management%20provider.dart';
import 'package:viewerapp/utils/strings.dart';
import 'package:viewerapp/utils/utils.dart';

import '../nav_controller.dart';


class ProfileScreen extends StatefulWidget {
  static String route = "/profile_screen";



  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late InAppWebViewController _controller;
  String?  language;


  @override
  Widget build(BuildContext context) {
    language = languagePreferences!.getString("language")??"ko";
    var provider = Provider.of<UserManagementProvider>(context, listen: false);
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String?>;



  String url =   args["user_id"] == null?"https://cheri.weeknday.com/viewer/profile?my=${args["encrypt_id"]}":"https://cheri.weeknday.com/viewer/profile?my=${args["encrypt_id"]}&m=${args["user_id"]}";

  print("urllll: ${url}");


    return Scaffold(
      body: SafeArea(
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

                      )
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {
                    setState(() {
                      _controller = controller;
                    });

                    _controller.addJavaScriptHandler(handlerName: "go_main", callback: (args) {
                      print(args);
                      switch(args[0]){
                        case "go_main":{
                           Navigator.pop(context);
                           break;
                        }
                        case "pw_change":{
                          Navigator.pop(context);
                          showToast("${passwordChanged[language]}");
                          break;
                        }

                        case  "log_out":{
                         provider.logout().then((value)  {
                           if(value) {
                             Navigator.pop(context);
                             showToast("${logoutMessage[language]}");
                           }
                           else
                             showToast("${logoutFailure[language]}");
                         });
                         break;
                        }
                        case  "delete_account":{
                          provider.logout().then((value)  {
                            if(value) {
                              showToast("${deleteAcountMessage[language]}");
                            }
                            else
                              showToast("${deleteAccountError[language]}");
                          });
                          break;
                        }


                      }


                    });
                    _controller.addJavaScriptHandler(handlerName: "change_language", callback: (args) {
                       languagePreferences!.setString("language", args[0]).then((value)  {
                         if(value){
                           showToast("${languageChanged[language]}");
                           Navigator.pop(context);

                         }
                         else {
                           showToast("${languageChangeError[language]}");
                         }
                       });
                    });
                  }),
      ),

    );
  }


}

//