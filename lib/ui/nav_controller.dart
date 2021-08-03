import 'package:connectivity/connectivity.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:viewerapp/business_logic/providers/collections%20provider.dart';
import 'package:viewerapp/business_logic/providers/home%20provider.dart';
import 'package:viewerapp/business_logic/providers/search%20provider.dart';
import 'package:viewerapp/ui/screens/webview main screen.dart';
import 'package:viewerapp/ui/screens/search_screen.dart';
import 'package:viewerapp/ui/screens/savedposts_screen.dart';
import 'package:viewerapp/utils/strings.dart';
import 'package:viewerapp/utils/utils.dart';

import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

class NavCotroller extends StatefulWidget {
  static String route = "/";

  @override
  _NavCotrollerState createState() => _NavCotrollerState();
}

class _NavCotrollerState extends State<NavCotroller> {
  int _selectedIndex = 0;
  String? language;
  var _screens = [];
  HomeProvider homeProvider = HomeProvider();
  CollectionsProvider collectionsProvider = CollectionsProvider();
  SearchProvider searchProvider = SearchProvider();
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  ScrollController _scrollController3 = ScrollController();
  double appBarHeight = 0;
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;
  late String? memberId;
  late  String? accountImgurl;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  void initState() {
    super.initState();

    this.initDynamicLinks();
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
    language = languagePreferences!.getString("language")??"ko";
     homeProvider = Provider.of<HomeProvider>(context, listen:false);
     searchProvider = Provider.of<SearchProvider>(context, listen: false);
     collectionsProvider = Provider.of<CollectionsProvider>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
     memberId = userPreferences!.getString("id")??"";
     print("memberId :${memberId}");
    accountImgurl = userPreferences!.getString("imgUrl")??"";
    _screens = [_buildHomeScreen(height, width), _buildSearchScreen(height, width), _buildStorageBoxScreen(height, width, memberId)];
    String string;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        string = "Offline";
        showToast("${turnonthenet[language]}");
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
    return  Scaffold(
            body: SafeArea(child: SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: CustomScrollView(
                controller: _selectedIndex == 0? _scrollController:_selectedIndex == 1?_scrollController2:_scrollController3,
                  slivers: [
                    _buildSliverAppBar(height, accountImgurl),
                    _screens[_selectedIndex]],
                ),
            ),),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label:  "홈"),
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
      child: SearchScreen(height, width, ""),
    );
  }

  Widget _buildStorageBoxScreen(double height, double width, String? memberId) {

    return SliverToBoxAdapter(
      child: StorageBoxScreen(height, width ),
    );
  }

  Widget _buildSliverAppBar(double height, String?  imgUrl) {

    return SliverAppBar(
      shadowColor: Colors.blue,
      elevation: 5,
      shape: Border(bottom: BorderSide(color: _selectedIndex==2?Colors.white:Colors.black54, width: 0.5,)),
      floating: true,
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      title: InkWell(
        onTap: () {
           homeProvider.cleanHomeScreen();
           searchProvider.cleanList();
           collectionsProvider.cleanCollections();
           setState(() {
             _selectedIndex = 0;
           });


        },
        child: Container(
            height: 29,
            width: 130,
            child: Image.asset(
              "assets/images/logo.png",
              color: Theme.of(context).selectedRowColor,
            )),
      ),
      actions: [
        if(imgUrl == "")
        IconButton(
            onPressed: () {
              String? encrypedId = (userPreferences!.getString("encrypt_id") ?? null);

              print("id");
              print(encrypedId);

              if (encrypedId == null) {
               print("yes");
                Navigator.pushNamed(context, AuthScreen.route).then((value)  {
                  setState(() {
                    memberId = userPreferences!.getString("id")??"";

                     accountImgurl= userPreferences!.getString("imgUrl")??"";
                  });
                });
              }else {

                Navigator.pushNamed(context, ProfileScreen.route, arguments: {"encrypt_id": encrypedId}).then((value) {
                  print("34uh4gruy4gyeryrgu24ruyerguyrgeurg");
                  setState(() {
                    language = languagePreferences!.getString("language")??"ko";
                    print("language ${language}");
                  });


                });
              }
                },
            icon: Icon(
              Icons.account_circle_outlined,
              size: 30,
              color: Colors.black54,
            )),
        if(imgUrl != "")
          Container(
            margin: EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                String? encrypedId = (userPreferences!.getString("encrypt_id") ?? null);
                print(encrypedId);

                Navigator.pushNamed(context, ProfileScreen.route, arguments: {"encrypt_id": encrypedId,  "user_id": null});
              },
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).selectedRowColor,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage("https://cheri.weeknday.com/${imgUrl!}"),
                ),
              ),
            ),
          )
      ],
    );
  }

  void _onItemSelected(int index) {


    if(_selectedIndex == index){
      if(index == 0){
      var homescreen = HomeScreen.scroll(_scrollController);
      homescreen.jumpToTheTop();}
      else if(index == 1){
        var  searchscreen = SearchScreen.scroll(_scrollController2);
        searchscreen.jumpToTheTop();
      }
      else if(index == 2){
        var  collectionscreen = StorageBoxScreen.scroll(_scrollController3);
        collectionscreen.jumpToTheTop();
      }
    }
    else
    setState(() {
      _selectedIndex = index;
    });
  }


  void _onRefresh() async{
    if(_selectedIndex == 0)
    homeProvider.cleanHomeScreen();
    else if(_selectedIndex == 1)
    searchProvider.cleanList();
    else if(_selectedIndex == 2)
    collectionsProvider.cleanCollections();
    setState(() {

    });

    await Future.delayed(Duration(milliseconds: 200));
    _refreshController.refreshCompleted();
  }
   
  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async  {
          if(dynamicLink != null){
             print("link ${dynamicLink.link.queryParametersAll}");
             Navigator.pushNamed(context, AuthScreen.route);
          }
          },
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
          return false;
        }

    );

    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data != null?data.link:null;
    if(deepLink!= null){
      print("second  $deepLink");
      Navigator.pushNamed(context, AuthScreen.route);
    }

  }
}
