import 'package:viewerapp/ui/child%20widgets/voice%20recorder%20modal%20bottom%20sheet.dart';
import 'package:viewerapp/ui/child%20widgets/singlepost_cardview_widget.dart';
import 'package:viewerapp/ui/child%20widgets/singlepost_listview_widget.dart';
import 'package:viewerapp/business_logic/providers/search provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/ui/screens/auth_screen.dart';
import 'package:viewerapp/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/strings.dart';
import 'dart:ui';

class SearchScreen extends StatefulWidget {
  double? height;
  double? width;
  String? searchword;
  ScrollController? _scrollController;

  SearchScreen(this.height, this.width, this.searchword);
  SearchScreen.scroll(this._scrollController);
  void  jumpToTheTop() => _scrollController!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeIn);


  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
   String? _memberId;
  bool _searchActive = false;
  bool _searching = false;
  bool _loaded = false;
  bool _noSearchResult = false;
  String?  language;


  @override
  void initState() {
    super.initState();
    _memberId = userPreferences!.getString("id")??"";
    if(widget.searchword!.isNotEmpty)
      _controller.text = widget.searchword!;

  }

  @override
  Widget build(BuildContext context) {
    language = languagePreferences!.getString("language")??"en";
    final modalHeight = (widget.height!.toDouble() - MediaQueryData.fromWindow(window).padding.top);
    if(widget.searchword!.isNotEmpty)
    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(left: widget.width!.toDouble() * 0.025, top: 10),
          child: Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              if (!_loaded && _memberId != "") {
                searchProvider.fetchRecentSearches(_memberId!).then((value) {});
                _loaded = true;
              }
              return _buildWidgetsList(searchProvider, modalHeight);
            },
          )),
    );
    else return Container(
        margin: EdgeInsets.only(left: widget.width!.toDouble() * 0.025, top: 10),
        child: Consumer<SearchProvider>(
          builder: (context, searchProvider, child) {
            if (!_loaded && _memberId != "") {
              searchProvider.fetchRecentSearches(_memberId!).then((value) {});
              _loaded = true;
            }
            return _buildWidgetsList(searchProvider, modalHeight);
          },
        ));
  }

  Widget _buildWidgetsList(SearchProvider searchProvider, double modalHeight) {
    int count = 2;
    if (searchProvider.searchResults.length > 0 && !_searching) {
      count = searchProvider.searchResults.length + count;
    } else if (searchProvider.searchResults.length == 0 && _noSearchResult) {
      count++;
    } else {
      if (!_searching) {
        if (_controller.text.isEmpty) {
          if (searchProvider.recentSearches.isEmpty)
            count++;
          else
            count = searchProvider.recentSearches.length + count;
        } else {
          if (searchProvider.relatedSearches.isEmpty)
            count++;
          else
            count = searchProvider.relatedSearches.length + count;
        }
      } else {
        count++;
      }
    }
    return _memberId != ""
        ? ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: count,
            itemBuilder: (BuildContext context, index) {
              if (index == 0) {
                return _buildSearchWidget(searchProvider,  modalHeight);
              } else if (index == 1) {
                if (searchProvider.searchResults.length > 0) {
                  return _buildSortWidget(_controller.text, searchProvider.searchResults.length, searchProvider);
                } else {
                  if (_controller.text.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      color: Color.fromRGBO(245, 245, 245, 1),
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "${recentSearch[language]}",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    );
                  } else
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      color: Color.fromRGBO(245, 245, 245, 1),
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "${relatedSearch[language]}",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    );
                }
              } else {
                index = index - 2;
                if (_searching) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.only(top: widget.width!.toDouble() *0.5),
                        child: CircularProgressIndicator(
                          color: Theme.of(context).selectedRowColor,

                    )),
                  );
                } else if (searchProvider.searchResults.length > 0) {
                  return _buildPostWidget(0.4 * widget.height!.toDouble(), widget.width!.toDouble(), index, searchProvider);
                } else if (searchProvider.searchResults.isEmpty && _noSearchResult) {
                  return Center(
                    child: Text(
                      "${noSearchResult[language]}",
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                } else if (_controller.text.isEmpty) {
                  if (searchProvider.recentSearches.isEmpty)
                    return Center(
                      child: Text(
                        "${noRelatedSearchResult[language]}",
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  else
                    return _buildRecentSearchResultWidget(searchProvider.recentSearches[index].word!, searchProvider);
                } else {
                  if (searchProvider.relatedSearches.isEmpty)
                    return Center(
                        child: Text(
                      "${noRelatedSearchResult[language]}",
                      style: TextStyle(fontSize: 15),
                    ));
                  return _buildRelatedSearchesWidget(searchProvider.relatedSearches[index].word!, searchProvider);
                }
              }
            })
        : Center(
      child: Container(
                margin: EdgeInsets.only(top: widget.width!.toDouble()*0.5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${toastSignIn[language]}",  style: TextStyle(
                        fontSize: 18
                      ),),
                    ),
        CupertinoButton(

                      color: Theme.of(context).selectedRowColor,
                      child: Text("${loginButton[language]}"), onPressed: (){
                    Navigator.pushNamed(context, AuthScreen.route);
                  })
                  ],
                )),
          );
  }

  Widget _buildSearchWidget(SearchProvider homePageProvider,  double modalHeight){
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: Container(
            height: widget.height!.toDouble() * 0.05,
            child: TextField(

              onChanged: (searchWord) {
                homePageProvider.cleanList();
                homePageProvider.fetchRelatedSearches(_memberId!, searchWord).then((value) {});
                setState(() {
                  _noSearchResult = false;
                });
              },
              onTap: () {
                _searchActive = true;
              },
              controller: _controller,
              onSubmitted: (searchWord) {

                if(searchWord.isEmpty) {
                  showToast("${emptySearchWord[language]}");
                }
                else  {
                  setState(() {
                    _searching = true;
                  });
                  homePageProvider.searchPostByTitle(10, 1, "views", searchWord, _memberId!).then((value) {
                    setState(() {
                      _searching = false;
                      if (homePageProvider.searchResults.isEmpty)
                        _noSearchResult = true;
                      else
                        _noSearchResult = false;
                    });
                  });
                }

              },
              autofocus: true,
              textAlign: TextAlign.start,
              decoration: InputDecoration(

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 1,color: Color.fromRGBO(175, 27, 63, 1)),
                ),
                contentPadding: EdgeInsets.only(left: 10.0),
                hintText: searchHint[korean],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        _searchActive
            ? Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 25,
                  ),
                  onPressed: () {
                    setState(() {
                      _searchActive = false;
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
                      _searchActive = true;
                    });

                    _showModalBottomSheet(homePageProvider, modalHeight);
                  },
                ))
      ],
    );
  }

  Widget _buildPostWidget(double height, double width, index, SearchProvider homePageProvider) {
    List<Post> posts = homePageProvider.searchResults;
    String mode = userPreferences!.getString("mode2") ?? "card";
    if (mode == "card")
      return CardViewWidget(height, width,  posts[index]);
    else
      return ListViewWidget(height, width,  posts[index]);
  }

  Widget _buildSortWidget(String searchWord, int count, SearchProvider homePageProvider) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(left: 5.0),
            child: PopupMenuButton(
                child: Container(width: 30, height: 30, child: SvgPicture.asset("assets/icons/list.svg")),
                elevation: 10,
                enabled: true,
                onSelected: (value) async {
                  if (value == "first1") {
                    await userPreferences!.setString("mode2", "card");
                  } else if (value == "first2") {
                    await userPreferences!.setString("mode2", "list");
                  }
                  setState(() {});
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text(menu1[korean]![0]),
                    value: "first1",
                  ),
                  PopupMenuItem(
                    child: Text(menu1[korean]![1]),
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
                    await homePageProvider.searchPostByTitle(10, 1, "regdate", searchWord, _memberId!);
                  } else if (value == "second2") {
                    await homePageProvider.searchPostByTitle(10, 1, "regdate", searchWord, _memberId!);
                  } else if (value == "second3") {
                    await homePageProvider.searchPostByTitle(10, 1, "views", searchWord, _memberId!);
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

  Widget _buildRecentSearchResultWidget(String recentSearchWord, SearchProvider searchProvider) {
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
                  onPressed: () {
                    setState(() {
                      _controller.text = recentSearchWord;
                      _searching = true;
                    });
                    searchProvider.searchPostByTitle(10, 1, "views", recentSearchWord, _memberId!).then((value) {
                      setState(() {
                        _searching = false;
                        if (searchProvider.searchResults.isEmpty)
                          _noSearchResult = true;
                        else
                          _noSearchResult = false;
                      });
                    });
                  },
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

  Widget _buildRelatedSearchesWidget(String relatedSearchWord, SearchProvider searchProvider) {
    return InkWell(
      onTap: () {
        setState(() {
          _controller.text = relatedSearchWord;

          _searching = true;
        });
        searchProvider.searchPostByTitle(10, 1, "views", relatedSearchWord, _memberId!).then((value) {
          setState(() {
            _searching = false;
            if (searchProvider.searchResults.isEmpty)
              _noSearchResult = true;
            else
              _noSearchResult = false;
          });
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Expanded(flex: 1, child: Icon(Icons.search)),
            Expanded(
              flex: 9,
              child: Text(
                relatedSearchWord,
                style: TextStyle(fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showModalBottomSheet( SearchProvider provider, double modalHeight) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => VoiceRecorderModalBottomSheet(modalHeight),
    ).then((value) {
      if (value != null) {
        setState(() {
          _searchActive = true;
          _controller.text = value;
          _searching = true;
        });
        provider.searchPostByTitle(10, 1, "views", value, _memberId!).then((value) {
          _searching = false;
          if (provider.searchResults.isEmpty)
            _noSearchResult = true;
          else
            _noSearchResult = false;

        });
      }
      else {
        setState(() {
          _searchActive = false;
          _searching = false;
        });
      }


    });
  }
}
