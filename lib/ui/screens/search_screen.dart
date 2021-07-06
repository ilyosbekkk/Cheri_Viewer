import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/business_logic/providers/search provider.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/ui/helper_widgets/singlepost_cardview_widget.dart';
import 'package:viewerapp/utils/utils.dart';

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
  late String memberId;
  bool searchActive = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    memberId = (preferences!.getString("id") ?? null)!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: widget.width * 0.025, top: 10),
        child: Consumer<SearchProvider>(
          builder: (context, searchProvider, child) {
            int count = 2;

            if(searchProvider.searchResults.length  > 0){
              count = searchProvider.searchResults.length + count;
            }
            else {
              if(_controller.text.isEmpty) {
                count = searchProvider.recentSearches.length + count;
              }
              else{
                count = searchProvider.relatedSearches.length + count;
              }
            }


            if (!_loaded) {
              searchProvider.fetchRecentSearches(memberId).then((value) {
                print("Hey done!!!");
              });
              _loaded = true;
            }
            return ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: searchProvider.searchResults.length != 0
                    ? searchProvider.searchResults.length + 2
                    : searchProvider.recentSearches.length != 0
                        ? searchProvider.recentSearches.length + 2
                        : 2,
                itemBuilder: (BuildContext context, index) {
                  if (index == 0) {
                    return _buildSearchWidget(searchProvider);
                  }
                  else if (index == 1) {
                    if (searchProvider.searchResults.length > 0) {
                      return _buildSortWidget(_controller.text, searchProvider.searchResults.length);
                    }
                    else {
                      if (_controller.text.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          color: Color.fromRGBO(245, 245, 245, 1),
                          margin: EdgeInsets.only(top: 10.0),
                          child: Text(
                            "최근검색",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      else return Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          color: Color.fromRGBO(245, 245, 245, 1),
                          margin: EdgeInsets.only(top: 10.0),
                          child: Text(
                            "관련된 검색어",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        );
                    }
                  }
                  else {
                    index = index - 2;
                    if (_controller.text.isEmpty) {
                      if (searchProvider.recentSearches.isEmpty)
                        return Center(
                          child: Text("결과 없다"),
                        );
                      else
                        return _buildRecentSearchResultWidget(searchProvider.recentSearches[index].word!);
                    } else {
                      if (searchProvider.searchResults.isEmpty) {
                        print("relates searches");
                        return _buildRelatedSearchesWidget(searchProvider.relatedSearches[index].word!);
                      }
                      else
                        return _buildPostWidget(0.4 * widget.height, widget.width, index, searchProvider);
                    }

                  }
                });
          },
        ));
  }

  Widget _buildSearchWidget(SearchProvider homePageProvider) {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: Container(
            height: widget.height * 0.05,
            child: TextField(
              onChanged: (searchWord) {
                homePageProvider.cleanList();
                homePageProvider.fetchRelatedSearches(memberId, searchWord).then((value) {});
                setState(() {});
              },
              onTap: () {
                searchActive = true;
              },
              controller: _controller,
              onSubmitted: (searchWord) {
                setState(() {
                  searching = true;
                });
                homePageProvider.searchPostByTitle(10, 1, "views", searchWord, memberId).then((value) {
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
        searchActive
            ? Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 25,
                  ),
                  onPressed: () {
                    setState(() {
                      searchActive = false;
                    });
                    _controller.text = "";
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              )
            : Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: () {
                    setState(() {
                      searchActive = true;
                    });
                  },
                ))
      ],
    );
  }

  Widget _buildPostWidget(double height, double width, index, SearchProvider homePageProvider) {
    List<Post> posts = homePageProvider.searchResults;
    return CardViewWidget(height, width, posts[index]);
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

  Widget _buildRecentSearchResultWidget(String recentSearchWord) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: Icon(Icons.access_time_outlined)),
          Expanded(
            flex: 8,
            child: Container(
                alignment: Alignment.bottomLeft,
                child: MaterialButton(
                  onPressed: () {},
                  child: Text(
                    recentSearchWord,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                )),
          ),
          Expanded(
              flex: 1,
              child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 15,
                  ),
                  onPressed: () {}))
        ],
      ),
    );
  }

  Widget _buildRelatedSearchesWidget(String relatedSearchWidget) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(top: 10),

        child: Row(
          children: [
            Icon(Icons.search),
            Text(
              relatedSearchWidget,
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
