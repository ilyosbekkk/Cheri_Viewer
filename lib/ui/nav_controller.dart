import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:viewerapp/ui/screens/profile_screen.dart';
import 'package:viewerapp/ui/screens/search_screen.dart';
import 'package:viewerapp/ui/screens/storage_screen.dart';
import 'package:viewerapp/utils/internet_connectivity.dart';
import 'package:viewerapp/utils/utils.dart';

import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

class NavCotroller extends StatefulWidget {
  static String route = "/";

  const NavCotroller();

  @override
  _NavCotrollerState createState() => _NavCotrollerState();
}

class _NavCotrollerState extends State<NavCotroller> {
  int _selectedIndex = 0;
  var _screens = [];
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  ScrollController _scrollController3 = ScrollController();
  double appBarHeight = 0;
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void initState() {

    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }
  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String? memberId = preferences!.getString("id")??null;
    _screens = [_buildHomeScreen(height, width), _buildSearchScreen(height, width), _buildStorageBoxScreen(height, width, memberId)];
    String string;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        string = "Offline";
        showToast("Please turn on the internet!");
        print(string);
        break;
      case ConnectivityResult.mobile:
        string = "Mobile: Online";
        print(string);
        break;
      case ConnectivityResult.wifi:
        string = "WiFi: Online";
        print(string);
         break;
    }


    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
            controller: _selectedIndex == 0?  _scrollController:_selectedIndex == 1?_scrollController2:_scrollController3,
            slivers: [_buildSliverAppBar(height), _screens[_selectedIndex]],
          ),

      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "검색"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: "보관함"),
        ],
        onTap: _onItemSelected,
        selectedItemColor: Theme.of(context).selectedRowColor,
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black38,
      ),
    );
  }

  Widget _buildHomeScreen(double height, double width) {
    return SliverToBoxAdapter(
      child: HomeScreen(height, width, context, _scrollController),
    );
  }

  Widget _buildSearchScreen(double height, double width) {
    return SliverToBoxAdapter(
      child: SearchScreen(height, width, _scrollController),
    );
  }

  Widget _buildStorageBoxScreen(double height, double width, String? memberId) {

    return SliverToBoxAdapter(
      child: StorageBoxScreen(height, width ),
    );
  }

  Widget _buildSliverAppBar(double height) {
    AppBar appBar = AppBar(
      title: Text('Demo'),
    );
    setState(() {
      appBarHeight = appBar.preferredSize.height;
    });

    return SliverAppBar(
      shadowColor: Colors.blue,
      elevation: 5,
      shape: Border(bottom: BorderSide(color: Colors.black26, width: 0.5)),
      floating: true,
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      title: Container(
          height: 29,
          width: 130,
          child: Image.asset(
            "assets/images/logo.png",
            color: Theme.of(context).selectedRowColor,
          )),
      actions: [
        IconButton(
            onPressed: () {
              String? encrypedId = (preferences!.getString("encrypt_id") ?? null);

              if (encrypedId == null) {
                print("hey1");
                Navigator.pushNamed(context, AuthScreen.route);
              }else {
                print("hey2");
                Navigator.pushNamed(context, ProfileScreen.route, arguments: {"encrypt_id": encrypedId});
              }
                },
            icon: Icon(
              Icons.account_circle_outlined,
              size: 30,
              color: Colors.black54,
            )),
      ],
    );
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}
