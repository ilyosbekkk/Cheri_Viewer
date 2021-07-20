import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:viewerapp/ui/child%20widgets/singlepost_cardview_widget.dart';
import 'package:viewerapp/ui/screens/categoryview_screen.dart';
import '../../business_logic/providers/home provider.dart';

import '../../models/postslist_model.dart';
import '../../utils/strings.dart';

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
  HomeProvider _homePageProvider = HomeProvider();
  int initialPage = 1;
  static const int pageSize = 10;
  static const int category = 0;
  static const orderBy = "views";
  bool  isListenerRegistered = false;
  bool netwrokCallDone = false;




  @override
  void dispose() {
    super.dispose();
    widget._scrollController.removeListener(() {
      print("Hello");});

  }

  @override
  Widget build(BuildContext context) {
    if(!netwrokCallDone) {
      netwrokCallDone = true;
      _homePageProvider = Provider.of<HomeProvider>(context, listen: true);
      if (_homePageProvider.reponseCode1 == 0 ||
          _homePageProvider.reponseCode1 == -2) {
        _homePageProvider.fetchPostsList(
            pageSize, initialPage, orderBy, category).then((value) {});
      }
      if (_homePageProvider.reponseCode2 == 0 ||
          _homePageProvider.reponseCode2 == -2) {
        _homePageProvider.fetchCategoriesList().then((value) {});
      }
    }
    if(!isListenerRegistered) {
      widget._scrollController.addListener(() {
        if (widget._scrollController.position.pixels == widget._scrollController.position.maxScrollExtent) {
          initialPage = initialPage  + 1;
          _homePageProvider.fetchPostsList(pageSize, initialPage, orderBy, category).then((value) {});
        }
      });
      isListenerRegistered  = true;
    }


    print(_homePageProvider.reponseCode1);
    print(_homePageProvider.reponseCode2);
    if (_homePageProvider.reponseCode1 == 200 &&_homePageProvider.reponseCode2 == 200)
      return  ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: _homePageProvider.allPosts.length != 0 ? _homePageProvider.allPosts.length + 1 : 2,
            itemBuilder: (BuildContext ctx, index) {
              if (index == 0) {
                return _buildCategories(widget.width);
              } else {
                return _homePageProvider.allPosts.length != 0 ? _buildSinglePost(index - 1, 0.4 * widget.height, widget.width) : Center(child: Container(margin: EdgeInsets.only(top: widget.width * 0.5), child: Text("List is empty:(")));
              }
            },
        );
    else if (_homePageProvider.reponseCode1 == -1 || _homePageProvider.reponseCode2 == -1)
      return Center(
        child: Column(
          children: [
            Text("TimeOut happened:("),
            MaterialButton(
              onPressed: () {
                if(_homePageProvider.reponseCode1 == -1)
                _homePageProvider.fetchPostsList(pageSize, initialPage, orderBy, category).then((value) {});
                if(_homePageProvider.reponseCode2 == -1)
                _homePageProvider.fetchCategoriesList().then((value) {});

              },
              child: Text("try again"),
            )
          ],
        ),
      );
    else if (_homePageProvider.reponseCode1 == -2 || _homePageProvider.reponseCode2 == -2) {
      return Center(
        child: Container(
          margin: EdgeInsets.only(top: widget.width * 0.5),
          child: Column(
            children: [
              Icon(Icons.wifi_off,  size: 30,),
              Text("Please check your internet connectivity!",  style: TextStyle(
                fontSize: 15
              ),),
              MaterialButton(
                color: Theme.of(context).selectedRowColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  if(_homePageProvider.reponseCode1 == -2)
                    _homePageProvider.fetchPostsList(pageSize, initialPage, orderBy, category).then((value) {});
                  if(_homePageProvider.reponseCode2 == -2)
                    _homePageProvider.fetchCategoriesList().then((value) {});
                  },
                child: Text("Reload Page"),
              )
            ],
          ),
        ),
      );
    }
    else if (_homePageProvider.reponseCode1 == -3 || _homePageProvider.reponseCode2 == -3) {
      return Center(
        child: Container(
          margin: EdgeInsets.only(top: widget.width * 0.5),
          child: Column(
            children: [
              Text("Unexpected error happened"),
              MaterialButton(
                onPressed: () {},
                child: Text("Try again"),
              )
            ],
          ),
        ),
      );
    }
    else return Center(
        child: Container(
            margin: EdgeInsets.only(top: widget.width * 0.5),
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).selectedRowColor,
            )),
      );
  }

  Widget _buildSinglePost(int index, double height, double width) {
    List<Post> posts = _homePageProvider.allPosts;

    return CardViewWidget(height, width, posts[index]);
  }

  Widget _buildCategories(double width) {
    var radius = width / 14;
    return Consumer<HomeProvider>(builder: (context, homeProvider, child) {
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
        if (homeProvider.showSubCategories1) _buildSubCategoriesB(homeProvider, homeProvider.activeIndex),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [_buildCategoryWidget(homeProvider, radius, 4)],
          ),
        ),
        if (homeProvider.showSubCategories2) _buildSubCategoriesB(homeProvider, homeProvider.activeIndex)
      ]);
    });
  }

  Widget _buildCategoryWidget(HomeProvider homeProvider, double radius, index) {
    String assetName = "";
    switch (index) {
      case 0:
        assetName = "assets/icons/health.svg";
        break;
      case 1:
        assetName = "assets/icons/life.svg";
        break;
      case 2:
        assetName = "assets/icons/education.svg";
        break;
      case 3:
        assetName = "assets/icons/it_content.svg";
        break;
      case 4:
        assetName = "assets/icons/personal_development.svg";
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
              color: homeProvider.activeAcategories[index] ? Theme.of(context).selectedRowColor : Colors.black,
            ),
          ),
          Container(
              width: 2 * radius,
              child: Text(
                categories[korean]![index],
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(color: homeProvider.activeAcategories[index] ? Theme.of(context).selectedRowColor : Colors.black, fontSize: 12),
              ))
        ],
      ),
    );
  }

  Widget _buildSubCategoriesB(HomeProvider homeProvider, int i) {
    return Container(
      child: Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          spacing: 10.0,
          children: List.generate(homeProvider.subCategories(i).length, (index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, CategoryViewScreen.route, arguments: {"id": homeProvider.categoryIds(i)[index], "title": homeProvider.subCategories(i)[index]});
              },
              child: Chip(
                  elevation: 5.0,
                  backgroundColor: Theme.of(context).buttonColor,
                  label: Text(
                    homeProvider.subCategories(i)[index],
                    style: Theme.of(context).textTheme.bodyText2,
                  )),
            );
          })),
    );
  }

}
