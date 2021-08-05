import 'package:viewerapp/ui/child%20widgets/voice%20recorder%20modal%20bottom%20sheet.dart';
import 'package:viewerapp/ui/child%20widgets/singlepost_cardview_widget.dart';
import 'package:viewerapp/ui/child%20widgets/singlepost_listview_widget.dart';
import 'package:viewerapp/business_logic/providers/search provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/ui/screens/auth_screen.dart';
import 'package:viewerapp/ui/screens/search%20result%20screen.dart';
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

  }

  @override
  Widget build(BuildContext context) {
    language = languagePreferences!.getString("language")??"ko";
    final modalHeight = (widget.height!.toDouble() - MediaQueryData.fromWindow(window).padding.top);

    return Container(
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
    int count = 1;
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


    return ListView.builder(
        shrinkWrap: true,
        itemCount: count,  itemBuilder: (context, index) {
      if(index == 0)
        return  _buildSearchWidget(searchProvider, modalHeight);
      else if(_controller.text.isEmpty){
        if(searchProvider.recentSearches.isNotEmpty){
          index = index - 1;
          return _buildRecentSearchResultWidget(searchProvider.recentSearches[index].word??"ㅇ", searchProvider);
        }
      else{
        return Container(
          margin: EdgeInsets.only(top: 0.3 * widget.height!.toInt()),
          child: Column(
           children: [
             Icon(Icons.announcement_rounded,  color: Theme.of(context).selectedRowColor,size: 30,),
             Text("No recent searches", style: TextStyle(
               fontSize: 20
             ),)
           ],
          ),
        );
        }
      }
      else{
        if(searchProvider.relatedSearches.isNotEmpty){
          index  = index - 1;
          return _buildRelatedSearchesWidget(searchProvider.relatedSearches[index].word??"", searchProvider);
        }
        else{
          return  Container(
            margin: EdgeInsets.only(top: 0.3 * widget.height!.toInt()),

            child: Column(
              children: [
                Icon(Icons.announcement_rounded,  color: Theme.of(context).selectedRowColor, size: 30,),
                Text("No related searches",  style: TextStyle(
                    fontSize: 20
                ),)
              ],
            ),
          );
        }
      }
    });


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
                  Navigator.pushNamed(context, Searchresultscreen.route,  arguments: {"searchWord":searchWord });

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
                    Navigator.pushNamed(context, Searchresultscreen.route,  arguments: {"searchWord":recentSearchWord });
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
        Navigator.pushNamed(context, Searchresultscreen.route,  arguments: {"searchWord":relatedSearchWord });
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
        Navigator.pushNamed(context, Searchresultscreen.route,  arguments: {"searchWord":value});
      }

    });

  }
}
