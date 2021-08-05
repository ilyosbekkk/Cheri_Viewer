import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/ui/child%20widgets/singlepost_cardview_widget.dart';
import 'package:viewerapp/ui/screens/categoryview_screen.dart';
import 'package:viewerapp/utils/utils.dart';
import '../../business_logic/providers/home provider.dart';

import '../../models/postslist_model.dart';
import '../../utils/strings.dart';

class HomeScreen extends StatefulWidget {
  double? height;
  double? width;
  BuildContext? context;
  ScrollController? _scrollController;


  HomeScreen(this.height, this.width, this.context, this._scrollController);

  HomeScreen.scroll(this._scrollController);

  void jumpToTheTop() => _scrollController!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeIn);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeProvider _homePageProvider = HomeProvider();
  int initialPage = 1;
  String? memberId;
  int currentLength = 0;
  String?  language;

   @override
  void initState() {
     super.initState();

   }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    memberId = "10475";
    // userPreferences!.getString("id")??"";


    _homePageProvider = Provider.of<HomeProvider>(context, listen: true);
    if (!_homePageProvider.networkCallDone) {
      _homePageProvider.networkCallDone = true;
      _homePageProvider.fetchPostsList(pageSize, initialPage, orderBy, category, memberId ?? "").then((value) {});
      _homePageProvider.fetchCategoriesList().then((value) {});
    }
    if (!_homePageProvider.scrollControllerRegistered) {
      _homePageProvider.scrollControllerRegistered = true;
      widget._scrollController!.addListener(() {
        if (widget._scrollController!.position.pixels == widget._scrollController!.position.maxScrollExtent) {
          initialPage = initialPage + 1;
          _homePageProvider.fetchPostsList(pageSize, initialPage, orderBy, category, memberId ?? "").then((value) {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  language = languagePreferences!.getString("language")??"ko";
    if (_homePageProvider.responseCode1 == 200 && _homePageProvider.responseCode2 == 200)
      return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: _homePageProvider.allPosts.length != 0 ? _homePageProvider.allPosts.length + 1 : 2,
        itemBuilder: (BuildContext ctx, index) {
          if (index == 0) {
            return _buildCategories(widget.width!.toDouble());
          } else if (index == _homePageProvider.allPosts.length) {
            if (currentLength == _homePageProvider.allPosts.length)
              return Center(
                  child: Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  "${lazyLoadinNoResult[AutofillHints.language]}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ));
            currentLength = _homePageProvider.allPosts.length;
            return Center(
                child: Container(
                    margin: EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      color: Theme.of(context).selectedRowColor,
                    )));
          } else {
            return _homePageProvider.allPosts.length != 0
                ? _buildSinglePost(index - 1, 0.4 * widget.height!.toDouble(), widget.width!.toDouble())
                : Center(child: Container(margin: EdgeInsets.only(top: widget.width! * 0.5), child: Text("List is empty:(")));
          }
        },
      );


    else if (_homePageProvider.responseCode1 == -1 || _homePageProvider.responseCode2 == -1) return Center(
        child: Column(
          children: [
            Text("${timeOutError[language]}"),
            MaterialButton(
              onPressed: () {
                if (_homePageProvider.responseCode1 == -1) _homePageProvider.fetchPostsList(pageSize, initialPage, orderBy, category, memberId!).then((value) {});
                if (_homePageProvider.responseCode2 == -1) _homePageProvider.fetchCategoriesList().then((value) {});
              },
              child: Text("try again"),
            )
          ],
        ),
      );
    else if (_homePageProvider.responseCode1 == -2 || _homePageProvider.responseCode2 == -2) {
      return Center(
        child: Container(
          margin: EdgeInsets.only(top: widget.width! * 0.5),
          child: Column(
            children: [
              Icon(
                Icons.wifi_off,
                size: 30,
              ),
              Text(
                "Please check your internet connectivity!",
                style: TextStyle(fontSize: 15),
              ),
              MaterialButton(
                color: Theme.of(context).selectedRowColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  if (_homePageProvider.responseCode1 == -2) _homePageProvider.fetchPostsList(pageSize, initialPage, orderBy, category, memberId!).then((value) {});
                  if (_homePageProvider.responseCode2 == -2) _homePageProvider.fetchCategoriesList().then((value) {});
                },
                child: Text("${reloadButton[language]}"),
              )
            ],
          ),
        ),
      );
    }
    else if (_homePageProvider.responseCode1 == -3 || _homePageProvider.responseCode2 == -3) {return Center(
        child: Container(
          margin: EdgeInsets.only(top: widget.width! * 0.5),
          child: Column(
            children: [
              Text("${unexpectedError[language]}"),
              MaterialButton(
                onPressed: () {},
                child: Text("${buttonTryAgain[language]}"),
              )
            ],
          ),
        ),
      );}
    else return Center(child: Container(
            margin: EdgeInsets.only(top: widget.width! * 0.5),
            child: CircularProgressIndicator(
                    color: Theme.of(context).selectedRowColor,
                  )
                ),);
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
                categories[language]![index],
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
      margin: EdgeInsets.only(left: 20),
      child: Align(
        alignment: Alignment.topLeft,
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
      ),
    );
  }
}
