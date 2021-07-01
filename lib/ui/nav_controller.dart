import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:viewerapp/ui/screens/search_screen.dart';
import 'package:viewerapp/ui/screens/storage_screen.dart';

import '../utils/strings.dart';
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
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  double  appBarHeight = 0;





  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    _screens = [
      _buildHomeScreen(height, width),
      _buildSearchScreen(height, width),
      _buildStorageBoxScreen(height, width)
    ];

    return Scaffold(

      body: SafeArea(
        child: SmartRefresher(
          onLoading: _onLoading,
          onRefresh: _onRefresh,
          controller: _refreshController,
          enablePullDown: true,


          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildSliverAppBar(height),
              _screens[_selectedIndex]
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label:  "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label:"검색"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border), label: "보관함"),
        ],
        onTap: _onItemSelected,
        selectedItemColor: Theme.of(context).selectedRowColor,
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black38,
      ) ,
    );
  }

  Widget _buildHomeScreen(double height,  double width) {
    return SliverToBoxAdapter(
      child: HomeScreen(height,  width, context,  _scrollController),
    );
  }

  Widget _buildSearchScreen(double height,  double width) {
    return SliverToBoxAdapter(
      child: SearchScreen(height,  width, _scrollController),
    );
  }

  Widget _buildStorageBoxScreen(double height,  double width) {
    return SliverToBoxAdapter(
      child: StorageBoxScreen(height,  width),
    );
  }

  Widget _buildSliverAppBar(double height){

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
          child: Image.asset("assets/images/logo.png", color: Theme.of(context).selectedRowColor,)),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen()));
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

  void _onRefresh() async{
    // monitor network fetch
    print("onrefresh");
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    print("onloading");

    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }

}
