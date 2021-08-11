

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/providers/search%20provider.dart';
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
  late String memberId;
  bool _loaded = false;
  UserManagementProvider _userManagementProvider = UserManagementProvider();
  String? language;
  bool _searching = true;
  var scrollConttoller = ScrollController();


  @override
  Widget build(BuildContext context) {
    _userManagementProvider = Provider.of<UserManagementProvider>(context, listen: true);

    language = languagePreferences!.getString("language")??"ko";
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    String memberId = _userManagementProvider.userId??"";

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      body: SafeArea(
          child:  Consumer<SearchProvider>(builder: (context, postProvider, widget) {
            if (!_loaded && _searching ){
              _loaded = true;
              _searching = false;
              postProvider.searchPostByTitle(pageSize, 1, orderBy, args["searchWord"], memberId).then((value) {

              });
            }
            if (_searching) return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).selectedRowColor,
                  )
              );
            else return CustomScrollView(
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
        child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: postListProvider.searchResults.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildSortWidget(searchWord, 5, postListProvider);
              } else {
                index = index - 1;
                return _buildSinglePost(index, height, width, postListProvider);
              }
            }));
  }

  Widget _buildDividedList(SearchProvider postListProvider, double height, double width) {
    return SliverToBoxAdapter(
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

        ));
  }

  Widget _buildSinglePost(int index, double height, double width, SearchProvider categoriesProvider) {
    List<Post> posts = categoriesProvider.searchResults;
    String mode = userPreferences!.getString("mode1") ?? "card";
    if (mode == "card")
      return CardViewWidget(height, width,  posts[index]);
    else
      return ListViewWidget(height, width,  posts[index]);
  }

  Widget _buildSortWidget(String searchWord, int count, SearchProvider postListsProvidert) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(

        children: [
          Container(
            margin:EdgeInsets.only(left: 10),
      child: Text("검색 결과: ${postListsProvidert.searchResults.length} 건",  style: TextStyle(
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
                  if (value == "second1") {
                    await postListsProvidert.searchPostByTitle(10, 1, "latestdate", searchWord, memberId);
                  } else if (value == "second2") {
                    await postListsProvidert.searchPostByTitle(10, 1, "olddate", searchWord, memberId);
                  } else if (value == "second3") {
                    await postListsProvidert.searchPostByTitle(10, 1, "views", searchWord, memberId);
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
