import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:viewerapp/business_logic/providers/postslist_provider%20%20.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/ui/helper_widgets/singlepost_cardview_widget.dart';
import 'package:viewerapp/utils/Strings.dart';

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
  String _popupValue1 = "";
  String _popupValue2 = "";
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    print(args["id"]);
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
              return CustomScrollView(
                slivers: [
                  _buildSliverAppBar(_height, args["title"]!),
                  _buildList(
                    postProvider,
                    0.4 * _height,
                    _width,
                  )
                ],
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
      shape: Border(bottom: BorderSide(color: Colors.black, width: 0.5)),
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

  Widget _buildList(PostListsProvider postListProvider, double height, double width) {
    return SliverToBoxAdapter(
        child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: postListProvider.categoryPosts.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildSortWidget("searchWord", 5);
              } else {
                if (postListProvider.categoryPosts.length == 0) {
                  print("heyyyyyyyyyyy");
                  return Center(
                    child: JumpingDotsProgressIndicator(
                      color: Theme.of(context).selectedRowColor,
                      fontSize: 100,
                    ),
                  );
                } else {
                  index = index - 1;
                  return _buildSinglePost(index, height, width, postListProvider);
                }
              }
            }));
  }

  Widget _buildSinglePost(int index, double height, double width, PostListsProvider postListProvider) {
    List<Post> posts = postListProvider.categoryPosts;
    return CardViewWidget(height, width, postListProvider, posts[index]);
  }

  void _onRefresh() async {
    // monitor network fetch
    print("onrefresh");
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    print("onloading");

    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Widget _buildSortWidget(String searchWord, int count) {
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
                onSelected: (value) {
                  setState(() {
                    _popupValue1 = value.toString();
                    print(_popupValue1);
                  });
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
                onSelected: (value) {
                  setState(() {
                    _popupValue2 = value.toString();
                    print(_popupValue1);
                  });
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
}
