import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/ui/widgets/individual_post_widget.dart';
import 'package:viewerapp/utils/Strings.dart';
import '../../business_logic/providers/mainpage_provider.dart';
import '../../models/post_model.dart';
import '../../utils/temp.dart';
import 'auth_screen.dart';

class MyHomePage extends StatefulWidget {
  static String route = "/";

  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //region  vars
  int _selectedIndex = 0;
  List<Widget> widget_options;
  List<Post> _posts = [];
  MainPageProvider _mainPageProvider;



  //endregion
  //region overrides

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _mainPageProvider = Provider.of<MainPageProvider>(context, listen: false);
    });

    _mainPageProvider.fetchPostsList().then((value) {
      setState(() {
        _posts.addAll(value);

      });
    });

  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    widget_options = [
      _buildHomeWidget(height, width),
      _buildSearchWidget(height, width),
      _buildFavoritesWidget(height, width)
    ];

    return Scaffold(
      body:SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            widget_options[_selectedIndex]
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: home),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: search),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: collections),
        ],
        onTap: _onItemSelected,
        selectedItemColor: Colors.greenAccent,
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black38,
      ),
    );
  }

  //endregion
  //region widgets
  Widget _buildHomeWidget(double height, double width) {
    return SliverToBoxAdapter(
      child: ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: _posts.length,
          itemBuilder: (BuildContext ctx, index) {
            return _buildHomeListViewVChild1(index, height, width);
          }),
    );
  }

  Widget _buildSearchWidget(double height, double width) {
    return SliverToBoxAdapter(  child: Container(
      margin: EdgeInsets.only( left: width * 0.025),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 9,
                child: Container(
                  height: height*0.05,
                  child: TextField(
                    autofocus: true,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10.0),
                      hintText: hint_text,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: MaterialButton(onPressed: () {

                }, child: const Text("츼소")),
              )
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildFavoritesWidget(double height, double width) {
    return SliverToBoxAdapter(child: Text("Favorites"));
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      title: Text(
        app_name,
        style: TextStyle(fontSize: 23, color: Colors.blue, fontWeight: FontWeight.bold),
      ),
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

  Widget _buildHomeListViewVChild1(int index, double height, double width) {
    return PostWidget(height * 0.4, width, posts[index]);
  }

  Widget _buildHomeListViewChild2() {
    return  Container();
  }

  //endregion

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
