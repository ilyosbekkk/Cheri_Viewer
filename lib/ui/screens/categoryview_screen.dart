import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:viewerapp/business_logic/providers/postslist_provider%20%20.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/ui/helper_widgets/singlepost_cardview_widget.dart';
import 'package:viewerapp/ui/helper_widgets/singlepost_listview_widget.dart';
import 'package:viewerapp/utils/strings.dart';
import 'package:viewerapp/utils/utils.dart';

class CategoryViewScreen extends StatefulWidget {
  static String route = "/categoryview_screen";

  CategoryViewScreen();

  @override
  _CategoryViewScreenState createState() => _CategoryViewScreenState();
}

class _CategoryViewScreenState extends State<CategoryViewScreen> {
  late double _height;
  late double _width;
  bool _loaded = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      body: SafeArea(
        child: SmartRefresher(
            onLoading: _onLoading,
            onRefresh: _onRefresh,
            controller: _refreshController,
            enablePullDown: true,
            child: Consumer<PostListsProvider>(builder: (context, postProvider, widget) {
              if (!_loaded) {
                postProvider.fetchPostsList(10, 1, "views", int.parse(args["id"]!)).then((value) {
                  _loaded = true;
                });
              }
              if (postProvider.categoryLoading)
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).selectedRowColor,
                  ),
                );
              else
                return CustomScrollView(
                  slivers: [_buildSliverAppBar(_height, args["title"]!), ((preferences!.getString("mode1") ?? "card") == "card") ? _buildList(postProvider, 0.4 * _height, _width, args["id"]!) : _buildDividedList(postProvider, 0.4 * _height, _width, args["id"]!)],
                );
            })),
      ),
    );
  }

  Widget _buildSliverAppBar(double height, String title) {
    return SliverAppBar(
      shadowColor: Colors.blue,
      elevation: 5,
      centerTitle: true,
      shape: ((preferences!.getString("mode1") ?? "card") == "card") ? Border(bottom: BorderSide(color: Colors.black, width: 0.5)) : Border(bottom: BorderSide(color: Colors.black, width: 0.0)),
      floating: true,
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_sharp,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildList(PostListsProvider postListProvider, double height, double width, String category) {
    return SliverToBoxAdapter(
        child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: postListProvider.categoryPosts.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildSortWidget("searchWord", 5, postListProvider, category);
              } else {
                index = index - 1;
                return _buildSinglePost(index, height, width, postListProvider);
              }
            }));
  }

  Widget _buildDividedList(PostListsProvider postListProvider, double height, double width, String category) {
    return SliverToBoxAdapter(
        child: ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: postListProvider.categoryPosts.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildSortWidget("searchWord", 5, postListProvider, category);
        } else {
          index = index - 1;
          return _buildSinglePost(index, height, width, postListProvider);
        }
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 1,
        color: Colors.black,
      ),
    ));
  }

  Widget _buildSinglePost(int index, double height, double width, PostListsProvider postListProvider) {
    List<Post> posts = postListProvider.categoryPosts;
    String mode = preferences!.getString("mode1") ?? "card";
    if (mode == "card")
      return CardViewWidget(height, width, postListProvider, posts[index]);
    else
      return ListViewWidget(height, width, postListProvider, posts[index]);
  }

  Widget _buildSortWidget(String searchWord, int count, PostListsProvider postListsProvidert, String category) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(left: 5.0),
            child: PopupMenuButton(
                child: Container(width: 30, height: 30, child: SvgPicture.asset("assets/icons/list.svg")),
                elevation: 10,
                enabled: true,
                onSelected: (value) async {
                  if (value == "first1") {
                    await preferences!.setString("mode1", "card");
                  } else if (value == "first2") {
                    await preferences!.setString("mode1", "list");
                  }
                  setState(() {});
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text(menu1[korean]![0]),
                        value: "first1",
                      ),
                      PopupMenuItem(
                        child: Text(menu1[korean]![1]),
                        value: "first2",
                      )
                    ]),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 10),
            child: PopupMenuButton(
                elevation: 10,
                child: Container(width: 30, height: 30, child: SvgPicture.asset("assets/icons/options.svg")),
                enabled: true,
                onSelected: (value) async {
                  if (value == "second1") {
                    await postListsProvidert.fetchPostsList(10, 1, "regdate r", int.parse(category));
                  } else if (value == "second2") {
                    await postListsProvidert.fetchPostsList(10, 1, "regdate", int.parse(category));
                  } else if (value == "second3") {
                    await postListsProvidert.fetchPostsList(10, 1, "views", int.parse(category));
                  }
                  setState(() {});
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text(menu2[korean]![0]),
                        value: "second1",
                      ),
                      PopupMenuItem(
                        child: Text(menu2[korean]![1]),
                        value: "second2",
                      ),
                      PopupMenuItem(
                        child: Text(menu2[korean]![2]),
                        value: "second3",
                      ),
                    ]),
          ),
        ],
      ),
    );
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch

    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }
}
