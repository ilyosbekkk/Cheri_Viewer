
import 'package:flutter/material.dart';
import 'package:viewerapp/ui/widgets/homepage_header_widget.dart';
import 'package:viewerapp/ui/widgets/individual_post_widget.dart';
import 'package:viewerapp/ui/widgets/search_widget.dart';
import 'package:viewerapp/utils/Strings.dart';
import '../../utils/dummy.dart';

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

  //endregion
  //region overrides
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    widget_options = [_buildHomeWidget(height, width), _buildSearchWidget(height, width), _buildFavoritesWidget(height, width)];

    return Scaffold(
      body: Container(
        child: widget_options[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: home),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: search),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: favorites),
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
    return Container(
      child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext ctx, index) {
            return _buildHomeChildren(index, height, width);
          }),
    );
  }

  Widget _buildSearchWidget(double height, double width) {
    return SearchWidget(height, width);
  }

  Widget _buildFavoritesWidget(double height, double width) {
    return Center(child: Text("Favorites"));
  }

  Widget _buildHomeChildren(int index, double height, double width) {
    if (index == 0)
      return  UserProfile();
    else if (index == 1)
      return Divider(height: 5, thickness: 1.0, color: Colors.greenAccent,);
    else
      return PostWidget(height * 0.4, width,posts[index]);
  }

  //endregion

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
