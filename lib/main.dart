import 'package:kakao_flutter_sdk/all.dart';
import 'package:viewerapp/business_logic/providers/postslist_provider  .dart';
import 'package:viewerapp/ui/nav_controller.dart';
import 'package:viewerapp/ui/screens/auth_screen.dart';
import 'package:viewerapp/ui/screens/categoryview_screen.dart';
import 'package:viewerapp/ui/screens/cheri_detail_screen.dart';
import 'package:viewerapp/ui/screens/profile_screen.dart';
import 'package:viewerapp/ui/screens/settings_screen.dart';
import 'business_logic/providers/auth_provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
    ),
    ChangeNotifierProvider(create: (_) => PostListsProvider()),
  ];

  runApp(MultiProvider(
    providers: providers,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        selectedRowColor: Color.fromRGBO(175, 27, 63, 1),
        buttonColor: Color.fromRGBO(245, 245, 245, 1),
        accentColor: Color.fromRGBO(255, 228, 228, 1),
        shadowColor: Color.fromRGBO(179, 183, 189, 1),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        primaryColorDark: Color.fromRGBO(0, 0, 0, 1),
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold, fontFamily: "RobotoMono"),
          headline6: TextStyle(fontSize: 18.0, fontStyle: FontStyle.normal, fontFamily: "RobotoMono"),
          bodyText2: TextStyle(fontSize: 14.0, fontStyle: FontStyle.normal, fontFamily: "RobotoMono"),
        ),
      ),
      initialRoute: "/",
      routes: {
        NavCotroller.route: (_) => NavCotroller(),
        AuthScreen.route: (_) => AuthScreen(),
        CheriDetailViewScreen.route: (_) => CheriDetailViewScreen(),
        CategoryViewScreen.route: (_) => CategoryViewScreen(),
        SettingsScreen.route: (_) => SettingsScreen(),
        ProfileScreen.route: (_) => ProfileScreen(),
      },
    );
  }
}
