import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/providers/category%20screen%20%20provider.dart';
import 'package:viewerapp/providers/user%20management%20provider.dart';
import 'package:viewerapp/ui/child%20widgets/singlepost_cardview_widget.dart';
import 'package:viewerapp/ui/child%20widgets/singlepost_listview_widget.dart';

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
  String? language;
  String sortWord = "views";
  UserManagementProvider userManagementProvider = UserManagementProvider();
  CategoriesProvider categoriesProvider = CategoriesProvider();
  var scrollController = ScrollController();
  int initPage = 1;
  int currentLength = 0;

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    categoriesProvider.fetchRequestDone = false;
    categoriesProvider.categories.clear();
    categoriesProvider.isScrollControllerRegistered = false;
  }

  @override
  Widget build(BuildContext context) {

    language = languagePreferences!.getString("language") ?? "ko";
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    userManagementProvider =
        Provider.of<UserManagementProvider>(context, listen: true);
    categoriesProvider = Provider.of<CategoriesProvider>(context, listen: true);

    if (!categoriesProvider.isScrollControllerRegistered) {
      categoriesProvider.isScrollControllerRegistered = true;
      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          initPage += 1;
          print("page: $initPage");
          categoriesProvider
              .fetchCategories(pageSize, initPage, sortWord,
                  int.parse(args["id"]!), userManagementProvider.userId ?? "")
              .then((value) {});
        }
      });
    }

    if (!categoriesProvider.fetchRequestDone) {
      print("dalbayob");
      categoriesProvider
          .fetchCategories(pageSize, 1, sortWord, int.parse(args["id"]!),
              userManagementProvider.userId ?? "")
          .then((value) {
        categoriesProvider.fetchRequestDone = true;
      });
    }

    return Scaffold(
        body: categoriesProvider.categoryLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Theme.of(context).selectedRowColor,
              ))
            : CustomScrollView(
                controller: scrollController,
                slivers: [
                  _buildSliverAppBar(_height, args["title"]!),
                  ((userPreferences!.getString("mode1") ?? "card") == "card")
                      ? _buildList(categoriesProvider, 0.4 * _height, _width,
                          args["id"]!)
                      : _buildDividedList(categoriesProvider, 0.4 * _height,
                          _width, args["id"]!)
                ],
              ));
  }

  Widget _buildSliverAppBar(double height, String title) {
    return SliverAppBar(
      shadowColor: Colors.blue,
      elevation: 5,
      centerTitle: true,
      shape: ((userPreferences!.getString("mode1") ?? "card") == "card")
          ? Border(bottom: BorderSide(color: Colors.black, width: 0.5))
          : Border(bottom: BorderSide(color: Colors.black, width: 0.0)),
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

  Widget _buildList(
    CategoriesProvider postListProvider,
    double height,
    double width,
    String category,
  ) {
    return SliverToBoxAdapter(
        child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: postListProvider.categories.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildSortWidget(
                    "searchWord", postListProvider, category);
              } else if (index == postListProvider.categories.length + 1) {
                if(currentLength == postListProvider.categories.length+1){
                  return Center(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "${lazyLoadinNoResult[language]}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ));
                }
                currentLength = postListProvider.categories.length+1;
                return Center(
                    child: Container(
                        margin: EdgeInsets.all(10),
                        child: CircularProgressIndicator(
                          color: Theme.of(context).selectedRowColor,
                        )));
              } else {
                index = index - 1;
                return _buildSinglePost(index, height, width, postListProvider);
              }
            }));
  }

  Widget _buildDividedList(CategoriesProvider postListProvider, double height,
      double width, String category) {
    return SliverToBoxAdapter(
        child: ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: postListProvider.categories.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildSortWidget("searchWord", postListProvider, category);
        } else if (index == postListProvider.categories.length + 1) {
          return Center(
              child: Container(
                  margin: EdgeInsets.all(10),
                  child: CircularProgressIndicator(
                    color: Theme.of(context).selectedRowColor,
                  )));
        } else {
          index = index - 1;
          return _buildSinglePost(index, height, width, postListProvider);
        }
      },
    ));
  }

  Widget _buildSinglePost(int index, double height, double width,
      CategoriesProvider categoriesProvider) {
    List<Post> posts = categoriesProvider.categories;
    String mode = userPreferences!.getString("mode1") ?? "card";
    if (mode == "card")
      return CardViewWidget(height, width, posts[index]);
    else
      return ListViewWidget(height, width, posts[index]);
  }

  Widget _buildSortWidget(String searchWord,
      CategoriesProvider postListsProvidert, String category) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(left: 5.0),
            child: PopupMenuButton(
                child: Container(
                    width: 30,
                    height: 30,
                    child: SvgPicture.asset("assets/icons/list.svg")),
                elevation: 10,
                enabled: true,
                onSelected: (value) async {
                  if (value == "first1") {
                    await userPreferences!.setString("mode1", "card");
                  } else if (value == "first2") {
                    await userPreferences!.setString("mode1", "list");
                  }
                  setState(() {});
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text(menu1[language]![0]),
                        value: "first1",
                      ),
                      PopupMenuItem(
                        child: Text(menu1[language]![1]),
                        value: "first2",
                      )
                    ]),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 10),
            child: PopupMenuButton(
                elevation: 10,
                child: Container(
                    width: 30,
                    height: 30,
                    child: SvgPicture.asset("assets/icons/options.svg")),
                enabled: true,
                onSelected: (value) async {
                  categoriesProvider.cleanCategoryScreen();
                  if (value == "second1") {
                      sortWord = "latestdate";
                  } else if (value == "second2") {
                    sortWord = "olddate";
                  } else if (value == "second3") {
                    sortWord = "views";
                  }
                  setState(() {});
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text(menu2[language]![0]),
                        value: "second1",
                      ),
                      PopupMenuItem(
                        child: Text(menu2[language]![1]),
                        value: "second2",
                      ),
                      PopupMenuItem(
                        child: Text(menu2[language]![2]),
                        value: "second3",
                      ),
                    ]),
          ),
        ],
      ),
    );
  }
}
