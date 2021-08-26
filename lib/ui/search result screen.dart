import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/providers/search%20screen%20provider.dart';
import 'package:viewerapp/providers/user%20management%20provider.dart';
import 'package:viewerapp/ui/child%20widgets/singlepost_cardview_widget.dart';
import 'package:viewerapp/ui/child%20widgets/singlepost_listview_widget.dart';

import 'package:viewerapp/utils/strings.dart';
import 'package:viewerapp/utils/utils.dart';

class Searchresultscreen extends StatefulWidget {
  static String route = "/search_result";


  @override
  _SearchresultscreenState createState() => _SearchresultscreenState();
}

class _SearchresultscreenState extends State<Searchresultscreen> {
  late double _height;
  late double _width;
  String sortWord = "views";
  UserManagementProvider _userManagementProvider = UserManagementProvider();
  SearchProvider _searchProvider = SearchProvider();
  String? language;
  int initPage = 1;
  var scrollController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
    _searchProvider.resultDone = false;
    _searchProvider.searching = true;
    _searchProvider.isControllerRegistered = false;
    _searchProvider.searchResults.clear();


  }

  @override
  Widget build(BuildContext context) {
    _userManagementProvider = Provider.of<UserManagementProvider>(context, listen: true);
    _searchProvider = Provider.of<SearchProvider>(context, listen: true);
    language = languagePreferences!.getString("language")??"ko";
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;


    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    print(args["searchWord"]);

    return Scaffold(
      body: SafeArea(
          child:  Consumer<SearchProvider>(builder: (context, postProvider, widget) {
            if(!postProvider.isControllerRegistered){
              postProvider.isControllerRegistered = true;
              scrollController.addListener(() {

                if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
                  initPage += 1;
                  postProvider.searchPostByTitle(pageSize, initPage, sortWord, args["searchWord"], _userManagementProvider.userId??"").then((value) {

                  });
                }
              });
            }


            if (!_searchProvider.resultDone && _searchProvider.searching ){
              _searchProvider.resultDone = true;
              postProvider.searchPostByTitle(pageSize, 1, sortWord, args["searchWord"], _userManagementProvider.userId??"").then((value) {
                _searchProvider.searching  = false;
              });
            }
            if (_searchProvider.searching )
              return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).selectedRowColor,
                  )
              );
            else if(postProvider.searchResults.length == 0)
              return Center(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 10, left: 10.0, right:10.0),
                        child: Text('${noResult[language]}',  style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)

                    )

                        ,
                    CupertinoButton(
                        color: Theme.of(context).selectedRowColor,
                        child: Text("${back[language]}"),
                        onPressed: () {
                        Navigator.pop(context);
                        })
                  ],
                )
              );
            else return CustomScrollView(
                controller: scrollController,
                slivers: [
                  _buildSliverAppBar(_height, args["searchWord"]!),
                  ((userPreferences!.getString("mode1") ?? "card") == "card") ?
                  _buildList(postProvider, 0.4 * _height, _width,  args["searchWord"]) : _buildDividedList(postProvider, 0.4 * _height, _width)],
              );
          })),
    );

  }

  Widget _buildSliverAppBar(double height, String title) {
    return SliverAppBar(
      shadowColor: Colors.blue,
      elevation: 5,
      centerTitle: true,
      shape: ((userPreferences!.getString("mode1") ?? "card") == "card") ? Border(bottom: BorderSide(color: Colors.black, width: 0.5)) : Border(bottom: BorderSide(color: Colors.black, width: 0.0)),
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

  Widget _buildList(SearchProvider postListProvider, double height, double width, String searchWord) {
    return SliverToBoxAdapter(
        child: Container(
          child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: postListProvider.searchResults.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildSortWidget(searchWord, 5, postListProvider);
                }
                else  if(index == postListProvider.searchResults.length+1){
                  return  Center(
                      child: Container(
                          margin: EdgeInsets.all(10),
                          child: CircularProgressIndicator(
                            color: Theme.of(context).selectedRowColor,
                          )));
                }
                else {
                  index = index - 1;
                  return _buildSinglePost(index, height, width, postListProvider);
                }
              }),
        ));
  }

  Widget _buildDividedList(SearchProvider postListProvider, double height, double width) {
    return SliverToBoxAdapter(
        child: Container(
          child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: postListProvider.searchResults.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildSortWidget("searchWord", 5, postListProvider);
              } else {
                index = index - 1;
                return _buildSinglePost(index, height, width, postListProvider);
              }
            },

          ),
        ));
  }

  Widget _buildSinglePost(int index, double height, double width, SearchProvider categoriesProvider) {
    List<Post> posts = categoriesProvider.searchResults;
    String mode = userPreferences!.getString("mode3") ?? "card";
    if (mode == "card")
      return CardViewWidget(height, width,  posts[index]);
    else
      return ListViewWidget(height, width,  posts[index]);
  }

  Widget _buildSortWidget(String searchWord, int count, SearchProvider postListsProvider) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(

        children: [
          Container(
            margin:EdgeInsets.only(left: 10),
      child: Text("검색 결과: ${postListsProvider.searchResults.length} 건",  style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),),),
          Spacer(),
          Container(
            margin: EdgeInsets.only(left: 5.0),
            child: PopupMenuButton(
                child: Container(width: 30, height: 30, child: SvgPicture.asset("assets/icons/list.svg")),
                elevation: 10,
                enabled: true,
                onSelected: (value) async {
                  if (value == "first1") {
                    await userPreferences!.setString("mode3", "card");
                  } else if (value == "first2") {
                    await userPreferences!.setString("mode3", "list");
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
                child: Container(width: 30, height: 30, child: SvgPicture.asset("assets/icons/options.svg")),
                enabled: true,
                onSelected: (value) async {
                  _searchProvider.cleanList();
                  if (value == "second1") {
                    sortWord = "latestdate";
                  }
                  else if (value == "second2") {
                    sortWord = "olddate";

                  }
                  else if (value == "second3") {
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
