import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/business_logic/providers/postslist_provider%20%20.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/ui/helper_widgets/singlepost_widget.dart';

import '../../utils/Strings.dart';

class StorageBoxScreen extends StatefulWidget {
  double height;
  double width;

  StorageBoxScreen(this.height, this.width);

  @override
  _StorageBoxScreenState createState() => _StorageBoxScreenState();
}

class _StorageBoxScreenState extends State<StorageBoxScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  PostListsProvider _homePageProvider = PostListsProvider();

  TextEditingController _controller = TextEditingController();
  bool _searchMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _homePageProvider = Provider.of<PostListsProvider>(context, listen: true);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: _searchMode ? 4 : 3,
        itemBuilder: (BuildContext context, index) {
          if (index == 0)
            return _buildCustomTabBar();
          else if (index == 1)
            return _buildSortWidget(_homePageProvider.posts.length);
          else if (_searchMode == true && index == 2)
            return _buildSearchWidget();
          else
            return _buildCustomTabView();
        });
  }




  Widget _buildCustomTabBar() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 5.0, right: 5.0),
      height: widget.height * 0.05,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        // give the indicator a decoration (color and border radius)
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
          color: Colors.blueAccent,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: [
          // first tab [you can add an icon using the icon property]
          Tab(
            text: bookmark_tab_kr,
          ),

          // second tab [you can add an icon using the icon property]
          Tab(
            text: opened_tab_kr,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabView() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      height: widget.height * 0.75,
      child: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
              itemCount: _homePageProvider.posts.length,
              itemBuilder: (BuildContext context, index) {
                return _buildPostWidget(0.4 * widget.height, widget.width,
                    index, _homePageProvider);
              }),
          ListView.builder(
              itemCount: _homePageProvider.posts.length,
              itemBuilder: (BuildContext context, index) {
                return _buildPostWidget(0.4 * widget.height, widget.width,
                    index, _homePageProvider);
              }),
        ],
      ),
    );
  }

  Widget _buildSortWidget(int count) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black26, // red as border color
        ),
      ),
      child: Row(
        children: [
          Container(
              margin: EdgeInsets.only(left: 10.0), child: Text('${count-1} 건')),
          Spacer(),
          IconButton(
              onPressed: () {
                setState(() {
                  _searchMode = !_searchMode;
                });
              },
              icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.menu_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.notes_outlined)),
        ],
      ),
    );
  }

  Widget _buildPostWidget(double height, double width, index, PostListsProvider homePageProvider) {
    List<Post> posts = homePageProvider.posts;
    return PostWidget(height, width, homePageProvider, posts[index]);
  }

  Widget _buildSearchWidget() {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 10),
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              height: widget.height * 0.05,
              child: TextField(
                controller: _controller,
                onSubmitted: (searchWord) {
                  print("${searchWord} submitted");
                },
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
            child: IconButton(icon: Icon(Icons.clear), onPressed: () {
              setState(() {
                _searchMode = false;
              });
            },),
          )
        ],
      ),
    );
  }

}
