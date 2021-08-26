import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/providers/saved%20posts%20screen%20provider.dart';
import 'package:viewerapp/providers/user%20management%20provider.dart';
import 'package:viewerapp/ui/child%20widgets/singlepost_cardview_widget.dart';
import 'package:viewerapp/ui/child%20widgets/singlepost_listview_widget.dart';

import 'package:viewerapp/utils/utils.dart';

import '../utils/strings.dart';
import 'auth_screen.dart';

// ignore: must_be_immutable
class StorageBoxScreen extends StatefulWidget {
  double? height;
  double? width;
  ScrollController? _scrollController;

  StorageBoxScreen(this.height, this.width, this._scrollController);

  StorageBoxScreen.scroll(this._scrollController);

  void jumpToTheTop() => _scrollController!.animateTo(0,
      duration: Duration(milliseconds: 500), curve: Curves.easeIn);

  @override
  _StorageBoxScreenState createState() => _StorageBoxScreenState();
}

class _StorageBoxScreenState extends State<StorageBoxScreen> {
  bool _searchMode = false;
  Button mode = Button.BOOKMARK;
  String sortWord1 = "views";
  String sortWord2 = "views";
  CollectionsProvider _collectionsProvider = CollectionsProvider();
  UserManagementProvider _userManagementProvider = UserManagementProvider();

  TextEditingController _textControllerB = TextEditingController();
  TextEditingController _textControllerO = TextEditingController();
  bool networkCallDone = false;
  String? language;
  int initPage1 = 1;
  int initPage2 = 1;
  int currentLength1 = 0;
  int currentLength2 = 0;

  @override
  void dispose() {
    super.dispose();

    _collectionsProvider.isScrollControllerRegistered = false;
    _collectionsProvider.cleanCollections();
  }

  @override
  Widget build(BuildContext context) {
    _collectionsProvider = Provider.of<CollectionsProvider>(context, listen: true);
    _userManagementProvider = Provider.of<UserManagementProvider>(context, listen: true);
    String memberId = _userManagementProvider.userId ?? "";
    language = languagePreferences!.getString("language") ?? "ko";
    int count = 2;

    addListenerToScroll();
    fetchAllData(memberId);


    if (memberId == "") {
      return _buildNoAuthWidget(memberId);
    }
    else {
      if (_collectionsProvider.statusCode1 == 200 && _collectionsProvider.statusCode2 == 200) return _buildItemList(setItemCount(count), memberId);
      else if (_collectionsProvider.statusCode1 == -2 || _collectionsProvider.statusCode2 == -2) {
        return _buildNoInternetWidget();
      }
      else {
        return _buildLoadingWidget();
      }
    }
  }

  //widgets
  Widget _buildNoAuthWidget(String  memberId){
    return Center(
      child: Container(
          margin: EdgeInsets.only(top: widget.width!.toDouble() * 0.5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "먼저 로그인 하십시오!",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              CupertinoButton(
                  color: Theme.of(context).selectedRowColor,
                  child: Text("로그인"),
                  onPressed: () {
                    _collectionsProvider.cleanCollections();
                    Navigator.pushNamed(context, AuthScreen.route)
                        .then((value) {
                      setState(() {
                        memberId = userPreferences!.getString("id") ?? "";
                      });
                    });
                  })
            ],
          )),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Container(
          margin: EdgeInsets.only(top: widget.width!.toDouble() * 0.5),
          child: CircularProgressIndicator(
            color: Theme.of(context).selectedRowColor,
          )),
    );
  }

  Widget _buildNoInternetWidget() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: widget.width!.toDouble() * 0.5),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () async {
                _collectionsProvider
                    .fetchSavedPostsList(_userManagementProvider.userId ?? "",
                        pageSize, 1, sortWord1)
                    .then((value) {});
                _collectionsProvider
                    .fetchOpenedPostsList(_userManagementProvider.userId ?? "",
                        pageSize, 1, sortWord2)
                    .then((value) {});
              },
              child: Text("Reload Page"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItemList(int count, String memberId) {

    int  finalCount = count;

    // if(_searchMode){
    //   if(mode == Button.BOOKMARK && _collectionsProvider.searchSavedPosts.isEmpty ||mode == Button.OPEN_CHERI && _collectionsProvider.searchOpenedPosts.isEmpty)
    //      finalCount =count;
    // }
    // else{
    //   if(mode == Button.BOOKMARK && _collectionsProvider.savedPosts.isEmpty ||mode == Button.OPEN_CHERI && _collectionsProvider.openedPosts.isEmpty)
    //     finalCount = count;
    // }

    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount:finalCount,
        itemBuilder: (BuildContext context, index) {
          if (index == 0) {
            return _buildCustomTabBar();
          }
          // else if ((mode == Button.BOOKMARK && (index == count)) || (mode == Button.OPEN_CHERI && (index == count))){
          //
          //   // if((mode == Button.BOOKMARK && currentLength1 == count)  || (mode == Button.OPEN_CHERI && currentLength2 == count)){
          //   //   return Center(
          //   //       child: Container(
          //   //         margin: EdgeInsets.all(10),
          //   //         child: Text(
          //   //           "${lazyLoadinNoResult[language]}",
          //   //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //   //         ),
          //   //       ));
          //   // }
          //   //
          //   // if(mode == Button.BOOKMARK){
          //   //   currentLength1 = count;
          //   // }
          //   // else if(mode == Button.OPEN_CHERI){
          //   //   currentLength2 = count;
          //   // }
          //   return Center(
          //       child: Container(
          //           margin: EdgeInsets.all(10),
          //           child: CircularProgressIndicator(color: Theme.of(context).selectedRowColor)));
          // }

          else if (index == 1) {
            return _buildSortWidget(memberId, _collectionsProvider);
          }
          else if (index == 2 && _searchMode) {
            return _buildSearchWidget();
          }
          else {
            if (_searchMode)
              index = index - 3;
            else
              index = index - 2;
            if (mode == Button.BOOKMARK) {
              if (_searchMode) {

                if (_collectionsProvider.searchSavedPosts.isEmpty) return _buildEmptyMessageBuilder();
                else
                  return _buildPostWidget(widget.height!.toDouble(), widget.width!.toDouble(), index, _collectionsProvider);
              } else {
                if (_collectionsProvider.savedPosts.isEmpty) return _buildEmptyMessageBuilder();
                else
                  return _buildPostWidget(widget.height!.toDouble(), widget.width!.toDouble(), index, _collectionsProvider);
              }
            } else {
              if (_searchMode) {
                if (_collectionsProvider.searchOpenedPosts.isEmpty)
                  return _buildEmptyMessageBuilder();
                else
                  return _buildPostWidget(widget.height!.toDouble(),
                      widget.width!.toDouble(), index, _collectionsProvider);
              } else {
                if (_collectionsProvider.openedPosts.isEmpty)
                  return _buildEmptyMessageBuilder();
                else
                  return _buildPostWidget(widget.height!.toDouble(),
                      widget.width!.toDouble(), index, _collectionsProvider);
              }
            }
          }
        });
  }

  Widget _buildCustomTabBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                mode = Button.BOOKMARK;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.transparent,
                  ),
                  left: BorderSide(color: Colors.transparent, width: 0.5),
                  right: BorderSide(color: Colors.transparent, width: 0.0),
                  bottom: mode == Button.BOOKMARK
                      ? BorderSide(
                          width: 2, color: Theme.of(context).selectedRowColor)
                      : BorderSide(color: Colors.grey),
                ),
              ),
              alignment: Alignment.center,
              height: 60,
              width: widget.width!.toDouble() / 2,
              child: Text(
                "${bookMarkScreen[language]}",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                mode = Button.OPEN_CHERI;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.transparent, width: 0.5),
                  left: BorderSide(color: Colors.transparent, width: 0.0),
                  right: BorderSide(color: Colors.transparent, width: 0.5),
                  bottom: mode == Button.OPEN_CHERI
                      ? BorderSide(
                          width: 2, color: Theme.of(context).selectedRowColor)
                      : BorderSide(color: Colors.grey),
                ),
              ),
              alignment: Alignment.center,
              height: 60,
              width: widget.width!.toDouble() / 2,
              child: Text("${openedCheri[language]}",
                  style: TextStyle(fontSize: 15)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSortWidget(String memberId, CollectionsProvider postListsProvidert) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                "${mode == Button.BOOKMARK ? _collectionsProvider.savedPosts.length : _collectionsProvider.openedPosts.length} ${count[language]}",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )),
          Spacer(),
          InkWell(
              onTap: () {
                setState(() {
                  _textControllerB.clear();
                  _textControllerO.clear();
                  _searchMode = !_searchMode;
                });
              },
              child: Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 25,
                  height: 25,
                  child: SvgPicture.asset(
                    "assets/icons/search.svg",
                    color: _searchMode
                        ? Theme.of(context).selectedRowColor
                        : Colors.black,
                  ))),
          if (!_searchMode)
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
                      await userPreferences!.setString("mode2", "card");
                    } else if (value == "first2") {
                      await userPreferences!.setString("mode2", "list");
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
          if (!_searchMode)
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
                    if (!_searchMode) {
                      _collectionsProvider.cleanCollections();
                      if (value == "second1") {
                        mode == Button.BOOKMARK? sortWord1 = "latestdate" : sortWord2 = "latestdate";
                      } else if (value == "second2") {
                        mode == Button.BOOKMARK? sortWord1 = "olddate" : sortWord2 = "olddate";
                      } else if (value == "second3") {
                        mode == Button.BOOKMARK? sortWord1 = "views" : sortWord2 = "views";
                      }
                      setState(() {});
                    }
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

  Widget _buildPostWidget(double height, double width, index, CollectionsProvider collectionsProvider) {
    List<Post> posts = [];
    if (mode == Button.BOOKMARK) {
      if (_searchMode)
        posts.addAll(collectionsProvider.searchSavedPosts);
      else
        posts.addAll(collectionsProvider.savedPosts);
    } else {
      if (_searchMode)
        posts.addAll(collectionsProvider.searchOpenedPosts);
      else
        posts.addAll(collectionsProvider.openedPosts);
    }
    String sortMode = userPreferences!.getString("mode2") ?? "card";
    if (sortMode == "card")
      return CardViewWidget(height, width, posts[index]);
    else
      return ListViewWidget(height, width, posts[index]);
  }

  Widget _buildSearchWidget() {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 10),
      child: Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: TextField(
          controller:
              mode == Button.BOOKMARK ? _textControllerB : _textControllerO,
          onSubmitted: (searchWord) {
            setState(() {
              _searchMode = false;
            });
          },
          onChanged: (word) {
            if (mode == Button.BOOKMARK) {
              _collectionsProvider.searchSaved(word);
            } else if (mode == Button.OPEN_CHERI) {
              _collectionsProvider.searchOpened(word);
            }
          },
          autofocus: true,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                if (mode == Button.BOOKMARK) {
                  _textControllerB.clear();
                  _collectionsProvider.searchSaved("");
                } else if (mode == Button.OPEN_CHERI) {
                  _textControllerO.clear();
                  _collectionsProvider.searchOpened("");
                }
              },
              icon:
                  Icon(Icons.clear, color: Theme.of(context).selectedRowColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide:
                  BorderSide(width: 1, color: Color.fromRGBO(175, 27, 63, 1)),
            ),
            contentPadding: EdgeInsets.only(left: 10.0),
            hintText: searchHint[language],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyMessageBuilder() {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 50),
        child: Text(
          "${noSavedPosts[language]}",
          style: TextStyle(
              fontSize: 20, color: Theme.of(context).selectedRowColor),
        ));
  }

  //utils
  int  setItemCount(int count) {
    print("res1");
    print(_collectionsProvider.savedPosts.length);
    print("res2");
    print(_collectionsProvider.openedPosts.length);

    if (_searchMode) count = count + 1;
    if (mode == Button.BOOKMARK) {
      if (_searchMode)
        count = _collectionsProvider.searchSavedPosts.isNotEmpty
            ? count + _collectionsProvider.searchSavedPosts.length
            : count + 1;
      else
        count = _collectionsProvider.savedPosts.isNotEmpty
            ? count + _collectionsProvider.savedPosts.length
            : count + 1;
    }
    else if (mode == Button.OPEN_CHERI) {
      if (_searchMode)
        count = _collectionsProvider.searchOpenedPosts.isNotEmpty
            ? count + _collectionsProvider.searchOpenedPosts.length
            : count + 1;
      else
        count = _collectionsProvider.openedPosts.isNotEmpty
            ? count + _collectionsProvider.openedPosts.length
            : count + 1;
    }

    return count;
  }
  void fetchAllData(String memberId) {
    if (!_collectionsProvider.networkCallDone && memberId.isNotEmpty) {
      _collectionsProvider.networkCallDone = true;
      if ((_collectionsProvider.statusCode1 == 0 ||
          _collectionsProvider.statusCode1 == -2)) {
        _collectionsProvider.fetchSavedPostsList(_userManagementProvider.userId ?? "", pageSize, 1, sortWord1).then((value) {});
      }
      if ((_collectionsProvider.statusCode2 == 0 ||
          _collectionsProvider.statusCode2 == -2)) {
        _collectionsProvider.fetchOpenedPostsList(
                _userManagementProvider.userId ?? "", pageSize, 1, sortWord2).then((value) {});
      }
    }
  }
  void addListenerToScroll() {
    if (!_collectionsProvider.isScrollControllerRegistered) {
      _collectionsProvider.isScrollControllerRegistered = true;
      widget._scrollController!.addListener(() {
        if (widget._scrollController!.position.pixels == widget._scrollController!.position.maxScrollExtent) {
          if (mode == Button.BOOKMARK) {
            initPage1 += 1;
            _collectionsProvider.fetchSavedPostsList(_userManagementProvider.userId ?? "", pageSize, initPage1, sortWord1).then((value) {});
          } else if (mode == Button.OPEN_CHERI) {
             initPage2 += 1;
            _collectionsProvider.fetchOpenedPostsList(_userManagementProvider.userId ?? "", pageSize, initPage2, sortWord2).then((value) {});
          }
        }
      });
    }
  }
}
