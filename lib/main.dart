import 'package:viewerapp/providers/categories%20provider.dart';
import 'package:viewerapp/providers/cheri%20provider.dart';
import 'package:viewerapp/providers/collections%20provider.dart';
import 'package:viewerapp/providers/detailedview%20provider.dart';
import 'package:viewerapp/providers/home%20provider.dart';
import 'package:viewerapp/providers/search%20provider.dart';
import 'package:viewerapp/providers/user%20management%20provider.dart';
import 'package:viewerapp/ui/cheri_detail_screen.dart';
import 'package:viewerapp/ui/categoryview_screen.dart';
import 'package:viewerapp/ui/search%20result%20screen.dart';
import 'package:viewerapp/ui/webview%20main%20screen.dart';
import 'package:viewerapp/ui/auth_screen.dart';
import 'package:provider/single_child_widget.dart';
import 'package:viewerapp/ui/nav_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:viewerapp/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  print("main is starting");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initPreferences();


  final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => UserManagementProvider(),),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    ChangeNotifierProvider(create: (_) => DetailedViewProvider()),
    ChangeNotifierProvider(create: (_) =>SearchProvider()),
    ChangeNotifierProvider(create: (_) =>CategoriesProvider()),
    ChangeNotifierProvider(create: (_) =>CollectionsProvider()),
    ChangeNotifierProvider(create: (_) =>CheriProvider()),
  ];


  runApp(
        MultiProvider(
          providers: providers,
          child: MyApp(),
        ));


}

class MyApp extends StatelessWidget {






  @override
  Widget build(BuildContext context) {
    var _userManagementProvider = Provider.of<UserManagementProvider>(context, listen: true);
    _userManagementProvider.setUserCredentials();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
        primaryColor: Color.fromRGBO(0, 149, 246, 1),
        selectedRowColor: Color.fromRGBO(175, 27, 63, 1),
        buttonColor: Color.fromRGBO(245, 245, 245, 1),
        accentColor: Color.fromRGBO(255, 228, 228, 1),
        shadowColor: Color.fromRGBO(179, 183, 189, 1),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        primaryColorDark: Color.fromRGBO(40, 40, 40, 0.8),
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold, fontFamily: "NotoSansKR"),
          headline6: TextStyle(fontSize: 18.0, fontStyle: FontStyle.normal, fontFamily: "NotoSansKR"),
          bodyText1: TextStyle(fontSize: 15.0, fontStyle: FontStyle.normal, fontFamily: "NotoSansKR"),
          bodyText2: TextStyle(fontSize: 12.0, fontStyle: FontStyle.normal, fontFamily: "NotoSansKR"),
        ),
      ),
      initialRoute: "/",

      routes: {
        NavCotroller.route: (_) => NavCotroller(),
        AuthScreen.route: (_) => AuthScreen(),
        CheriDetailViewScreen.route: (_) => CheriDetailViewScreen(),
        CategoryViewScreen.route: (_) => CategoryViewScreen(),
        ProfileScreen.route: (_) => ProfileScreen(),
        Searchresultscreen.route: (_) => Searchresultscreen()
      },
    );
  }
}


