import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
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
  HomePageProvider _homePageProvider = HomePageProvider();
  int initialPage = 1;
  static const int  pageSize = 10;
  static const int category = 0;
  static const  orderBy = "views";
  bool _noMoreData = false;



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homePageProvider = Provider.of<HomePageProvider>(context, listen: true);

    print(_homePageProvider.message);
    print(_homePageProvider.posts);
    if(_homePageProvider.message  == ""){
      _homePageProvider.fetchPostsList(pageSize+1, initialPage, orderBy, category).then((value) {
        if(value == true){
         print("list1");
        }
      });
    }
    widget._scrollController.addListener(() {
      if (widget._scrollController.position.pixels == widget._scrollController.position.maxScrollExtent) {
        initialPage = initialPage + 1;
        _homePageProvider.fetchPostsList(pageSize+1, initialPage, "views", 0).then((value) {
          if(value == true){
            print("list2");

          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        primary: false,

        shrinkWrap: true,
        itemCount: _homePageProvider.posts.length != 0 ? _homePageProvider.posts.length + 1 : 2,
        itemBuilder: (BuildContext ctx, index) {
          if (index == 0) {
            return _buildCategories(widget.width);
          }
          else if (index == _homePageProvider.posts.length )
            return _buildCustomLoadingWidget();
          else {

            return _homePageProvider.posts.length != 0
                ? _buildSinglePost(index-1, 0.4 * widget.height, widget.width)
                : Center(
                    child: Container(
                        child: JumpingDotsProgressIndicator(
                      fontSize: 60,
                      color: Colors.lightBlue,
                    )),
                  );
          }
        });
  }

  Widget _buildSinglePost(int index, double height, double width) {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
      height: height,
      width: double.infinity,
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: height * 0.65,
                width: width,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder.png',
                        image: _homePageProvider.posts[index].imgUrl,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: width * 0.2,
                          margin: EdgeInsets.only(left: 10.0, top: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          child: Text(
                            "구매.판매",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                       Container(
                            child: !_homePageProvider.posts[index].like
                                ? IconButton(
                                    icon: Icon(
                                      Icons.bookmark_border,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _homePageProvider.bookmark(_homePageProvider.posts[index]);
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.bookmark,
                                      size: 25.0,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _homePageProvider
                                          .unbookmark(_homePageProvider.posts[index]);
                                    },
                                  ),
                          ),

                      ],
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(left: 10.0, top: 5.0),
              child: Text(
                _homePageProvider.posts[index].title,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0, top: 5.0),
              child: Text(
                _homePageProvider.posts[index].author,
                style: TextStyle(fontSize: 15),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0, top: 5.0),
              child: Row(
                children: [
                  Text(
                    "$views_kr:${_homePageProvider.posts[index].views}",
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 3.0, right: 3.0),
                      child: Icon(
                        Icons.circle,
                        size: 5.0,
                      )),
                  Text(
                    "${_homePageProvider.posts[index].dateTime}",
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(double width) {
    var radius = width / 14;
    return Consumer<HomePageProvider>(builder: (context, homeProvider, child) {
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
        if (homeProvider.showSubCategories1) _buildSubCategories(homeProvider),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [_buildCategoryWidget(homeProvider, radius, 4)],
          ),
        ),
        if (homeProvider.showSubCategories2) _buildSubCategories(homeProvider)
      ]);
    });
  }

  Widget _buildCategoryWidget(HomePageProvider homeProvider, double radius, index) {
    return InkWell(
      onTap: () {
        homeProvider.fetchSubCategories(categories[index], index);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: Colors.lightBlueAccent,
            child: CircleAvatar(
              radius:
                  homeProvider.activeAcategories[index] ? 0.9 * radius : radius,
              backgroundImage: AssetImage("assets/images/logo.png"),
            ),
          ),
          Container(
              width: 2 * radius,
              child: Text(
                categories[index],
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: homeProvider.activeAcategories[index]
                        ? Colors.lightBlueAccent
                        : Colors.black),
              ))
        ],
      ),
    );
  }

  Widget _buildSubCategories(HomePageProvider homeProvider) {
    return Container(
      margin: EdgeInsets.all(10),
      child: GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.all(5.0),
          crossAxisCount: 4,
          childAspectRatio: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: List.generate(homeProvider.subCategories.length, (index) {
            return MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {},
              color: Colors.amberAccent,
              child: Text(
                homeProvider.subCategories[index],
                maxLines: 1,
              ),
            );
          })),
    );
  }

  Widget _buildCustomLoadingWidget() {
    if(!_noMoreData)
      return  JumpingDotsProgressIndicator(
        color: Colors.blue,
        fontSize: 50.0,
      );
    else  return Center(child: Container(
        margin: EdgeInsets.all(10),
        child: Text("No more results:(",  style: TextStyle(
            fontSize: 18
        ),)),);
  }
}
