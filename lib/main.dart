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
      theme: ThemeData(primarySwatch: Colors.blue, primaryColor: Colors.blue),
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
