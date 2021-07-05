import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/business_logic/providers/postslist_provider%20%20.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/ui/helper_widgets/singlepost_cardview_widget.dart';

import '../../utils/strings.dart';

class SearchScreen extends StatefulWidget {
  double height;
  double width;
  ScrollController _scrollController;

  SearchScreen(this.height, this.width, this._scrollController);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  bool searching = false;
  String _popupValue1 = "";
  String _popupValue2 = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("final");
    return Container(
        margin: EdgeInsets.only(left: widget.width * 0.025, top: 10),
        child: Consumer<PostListsProvider>(
          builder: (context, homepageProvider, child) {
            return ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: homepageProvider.searchResults.length != 0 ? homepageProvider.searchResults.length + 2 : 2,
                itemBuilder: (BuildContext context, index) {
                  if (index == 0)
                    return _buildSearchWidget(homepageProvider);
                  else if (index == 1 && homepageProvider.searchResults.length > 0) {
                    return _buildSortWidget(_controller.text, homepageProvider.searchResults.length);
                  } else {
                    index = index - 2;
                    return homepageProvider.searchResults.length > 0
                        ? _buildPostWidget(0.4 * widget.height, widget.width, index, homepageProvider)
                        : Center(
                            child: searching
                                ? Container(
                                    margin: EdgeInsets.only(top: 16),
                                    child: CircularProgressIndicator(
                                      backgroundColor: Theme.of(context).selectedRowColor,
                                    ))
                                : Container(margin: EdgeInsets.only(top: 16), child: Text("검색 결과가 없습니다")));
                  }
                });
          },
        ));
  }

  Widget _buildSearchWidget(PostListsProvider homePageProvider) {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: Container(
            height: widget.height * 0.05,
            child: TextField(
              controller: _controller,
              onSubmitted: (searchWord) {
                setState(() {
                  searching = true;
                });
                homePageProvider.searchPostByTitle(10, 1, "views", searchWord).then((value) {
                  setState(() {
                    searching = false;
                  });
                });
              },
              autofocus: true,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0),
                hintText: search_hint[korean],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: MaterialButton(onPressed: () {}, child: const Text("츼소")),
        )
      ],
    );
  }

  Widget _buildPostWidget(double height, double width, index, PostListsProvider homePageProvider) {
    List<Post> posts = homePageProvider.searchResults;
    return CardViewWidget(height, width, homePageProvider, posts[index]);
  }

  Widget _buildSortWidget(String searchWord, int count) {
    return Row(
      children: [
        Container(margin: EdgeInsets.only(left: 10.0), child: Text('${searchWord} 검색 결과 ${count} 건')),
        Spacer(),
        Container(
          margin: EdgeInsets.only(left: 5.0),
          child: PopupMenuButton(
              child: Icon(Icons.menu),
              elevation: 10,
              enabled: true,
              onSelected: (value) {
                setState(() {
                  _popupValue1 = value.toString();
                });
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("First"),
                      value: "first1",
                    ),
                    PopupMenuItem(
                      child: Text("Second"),
                      value: "second1",
                    )
                  ]),
        ),
        Container(
          margin: EdgeInsets.only(left: 10.0, right: 10),
          child: PopupMenuButton(
              elevation: 10,
              child: Icon(
                Icons.notes_outlined,
              ),
              enabled: true,
              onSelected: (value) {
                setState(() {
                  _popupValue2 = value.toString();
                });
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("First"),
                      value: "first2",
                    ),
                    PopupMenuItem(
                      child: Text("Second"),
                      value: "second2",
                    )
                  ]),
        ),
      ],
    );
  }
}
