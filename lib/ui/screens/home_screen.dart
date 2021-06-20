import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../business_logic/providers/mainscreen_provider.dart';

import '../../business_logic/services/web_services.dart';
import '../../models/postslist_model.dart';
import '../../utils/Strings.dart';

class HomeScreen extends StatefulWidget {
  double height;
  double width;
  BuildContext context;

  HomeScreen(this.height, this.width, this.context);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();

    WebServices.fetchPosts().then((value) {
      print(value.length);
      setState(() {
        _posts = value;

      });
    });

  }

  @override
  Widget build(BuildContext context) {
    print("posts");
    print(_posts);
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: _posts.length,
        itemBuilder: (BuildContext ctx, index) {
          if (index == 0)
            return _buildCategories(widget.width);
          else
            return _buildSinglePost(index, 0.4 * widget.height, widget.width);
        });
  }

  Widget _buildSinglePost(int index, double height, double width) {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
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
                        image: _posts[index].imgUrl,
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
                          decoration: BoxDecoration(color: Colors.black54, border: Border.all(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(5.0))),
                          child: Text(
                            "구매.판매",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Consumer<HomePageProvider>(builder: (context, homePageProvider, child) {
                          return Container(
                            child: !_posts[index].like
                                ? IconButton(
                              icon: Icon(
                                Icons.bookmark_border,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                homePageProvider.like(_posts[index]);
                              },
                            )
                                : IconButton(
                              icon: Icon(
                                Icons.bookmark,
                                size: 25.0,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                homePageProvider.unLike(_posts[index]);
                              },
                            ),
                          );
                        })
                      ],
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(left: 10.0, top: 5.0),
              child: Text(
                _posts[index].title,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0, top: 5.0),
              child: Text(
                _posts[index].author,
                style: TextStyle(fontSize: 15),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0, top: 5.0),
              child: Row(
                children: [
                  Text(
                    "Views:${_posts[index].views}",
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 3.0, right: 3.0),
                      child: Icon(
                        Icons.circle,
                        size: 5.0,
                      )),
                  Text(
                    "${_posts[index].dateTime} hours ago",
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
        if (homeProvider.showSubCategories1)
          _buildSubCategories(homeProvider),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [_buildCategoryWidget(homeProvider, radius, 4)],
          ),
        ),
        if (homeProvider.showSubCategories2)
          _buildSubCategories(homeProvider)
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
              radius: homeProvider.activeAcategories[index] ? 0.9 * radius: radius,
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
                  color: homeProvider.activeAcategories[index]?Colors.lightBlueAccent:Colors.black
                ),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
}
