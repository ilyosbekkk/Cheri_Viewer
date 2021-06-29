import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/ui/helper_widgets/singlepost_widget.dart';
import 'package:viewerapp/ui/screens/categoryview_screen.dart';
import '../../business_logic/providers/postslist_provider  .dart';

import '../../models/postslist_model.dart';
import '../../utils/Strings.dart';

class HomeScreen extends StatefulWidget {
  double height;
  double width;
  BuildContext context;
  ScrollController _scrollController;

  HomeScreen(this.height, this.width, this.context, this._scrollController);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PostListsProvider _homePageProvider = PostListsProvider();
  int initialPage = 1;
  static const int pageSize = 10;
  static const int category = 0;
  static const orderBy = "views";
  bool _noMoreData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homePageProvider = Provider.of<PostListsProvider>(context, listen: true);

    if (_homePageProvider.postsMessage == "") {
      _homePageProvider.fetchPostsList(pageSize, initialPage, orderBy, category).then((value) {
        if (value == true) {
          print("list1");
        }
      });
    }

    if (_homePageProvider.categoriesMessage == "") {
      _homePageProvider.fetchCategoriesList().then((value) {
        print("you are done");
      });
    }

    // widget._scrollController.addListener(() {
    //   if (widget._scrollController.position.pixels == widget._scrollController.position.maxScrollExtent) {
    //     initialPage = initialPage + 1;
    //     _homePageProvider.fetchPostsList(pageSize+1, initialPage, "views", 0).then((value) {
    //       if(value == true){
    //         print("list2");
    //
    //       }
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: _homePageProvider.allPosts.length != 0 ? _homePageProvider.allPosts.length + 1 : 2,
        itemBuilder: (BuildContext ctx, index) {
          if (index == 0) {
            return _buildCategories(widget.width);
          }
          // else if (index == _homePageProvider.posts.length )
          //   return _buildCustomLoadingWidget();
          else {
            return _homePageProvider.allPosts.length != 0
                ? _buildSinglePost(index - 1, 0.4 * widget.height, widget.width)
                : Center(
                    child: Container(
                        child: JumpingDotsProgressIndicator(
                      fontSize: 100,
                      color: Colors.lightBlue,
                    )),
                  );
          }
        });
  }

  Widget _buildSinglePost(int index, double height, double width) {
    List<Post> posts = _homePageProvider.allPosts;
    return PostWidget(height, width, _homePageProvider, posts[index]);
  }

  Widget _buildCategories(double width) {
    var radius = width / 14;
    return Consumer<PostListsProvider>(builder: (context, homeProvider, child) {
      return Column(children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCategoryWidget(homeProvider, radius, 0),
              _buildCategoryWidget(homeProvider, radius, 1),
              _buildCategoryWidget(homeProvider, radius, 2),
              _buildCategoryWidget(homeProvider, radius, 3),
            ],
          ),
        ),
        if (homeProvider.showSubCategories1) _buildSubCategories(homeProvider, homeProvider.activeIndex),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [_buildCategoryWidget(homeProvider, radius, 4)],
          ),
        ),
        if (homeProvider.showSubCategories2) _buildSubCategories(homeProvider, homeProvider.activeIndex)
      ]);
    });
  }

  Widget _buildCategoryWidget(PostListsProvider homeProvider, double radius, index) {
    String assetName = "";
    switch(index) {
      case 0: assetName = "assets/icons/health.svg";
      break;
      case 1: assetName = "assets/icons/life.svg";
      break;
      case 2: assetName  ="assets/icons/education.svg";
      break;
      case 3: assetName  ="assets/icons/it_content.svg";
      break;
      case 4: assetName  ="assets/icons/personal_development.svg";
      break;

    }
    return InkWell(
      onTap: () {
        homeProvider.showCategories(index);
      },
      child: Column(
        children: [
          Container(
            height: 30,
            width: 30,
            child: SvgPicture.asset(
              assetName,
              color:homeProvider.activeAcategories[index] ?Theme.of(context).selectedRowColor : Colors.black,
            ),
          ),
          Container(
              width: 2 * radius,
              child: Text(
                categories[korean]![index],
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: homeProvider.activeAcategories[index] ? Theme.of(context).selectedRowColor : Colors.black,
                    fontSize: 12),
              ))
        ],
      ),
    );
  }

  Widget _buildSubCategories(PostListsProvider homeProvider, int i) {
    print(homeProvider.subCategories(i).length);
    return Container(
      margin: EdgeInsets.all(10),
      child: GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.all(5.0),
          crossAxisCount: 4,
          childAspectRatio: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: List.generate(homeProvider.subCategories(i).length, (index) {
            return MaterialButton(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                Navigator.pushNamed(context, CategoryViewScreen.route, arguments: {"id": homeProvider.categoryIds(i)[index], "title": homeProvider.subCategories(i)[index]});
              },
              color: Theme.of(context).buttonColor,
              child: Text(
                homeProvider.subCategories(i)[index],
                maxLines: 1,
                style:  Theme.of(context).textTheme.bodyText2,
              ),
            );
          })),
    );
  }
}
