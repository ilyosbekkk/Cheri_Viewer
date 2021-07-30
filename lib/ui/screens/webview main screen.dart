import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/business_logic/providers/user%20management%20provider.dart';
import 'package:viewerapp/utils/strings.dart';
import 'package:viewerapp/utils/utils.dart';

import '../nav_controller.dart';


class ProfileScreen extends StatefulWidget {
  static String route = "/profile_screen";

  const ProfileScreen();

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late InAppWebViewController _controller;
  String?  language;


  @override
  Widget build(BuildContext context) {
    language = languagePreferences!.getString("language")??"en";
    var provider = Provider.of<UserManagementProvider>(context, listen: false);
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
                      print(args);
                      switch(args[0]){
                        case "go Main":{
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
                             Navigator.pushNamedAndRemoveUntil(context, NavCotroller.route, (r) => false);
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
                              Navigator.pushNamedAndRemoveUntil(context, NavCotroller.route, (r) => false);
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
