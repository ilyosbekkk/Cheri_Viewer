
import 'package:viewerapp/business_logic/providers/mainpage_provider.dart';
import 'business_logic/providers/individualpost_provider.dart';
import 'package:viewerapp/ui/screens/home_screen.dart';
import 'business_logic/providers/auth_provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => PostProvider()),
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
    ),
    ChangeNotifierProvider(create: (_) => MainPageProvider()),
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
        primaryColor: Colors.blue
      ),
      initialRoute: MyHomePage.route,
      routes: {
        MyHomePage.route: (_) => MyHomePage(),
      },
    );
  }
}
