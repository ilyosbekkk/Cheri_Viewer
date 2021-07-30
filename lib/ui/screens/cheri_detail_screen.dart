import 'package:flutter/cupertino.dart';
import 'package:viewerapp/business_logic/providers/detailedview provider.dart';
import 'package:viewerapp/models/detailedpost_model.dart';
import 'package:viewerapp/ui/screens/search_screen.dart';
import 'package:viewerapp/utils/strings.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:viewerapp/utils/utils.dart';

class CheriDetailViewScreen extends StatefulWidget {
  static String route = "/cheridetail_screen";

  const CheriDetailViewScreen();

  @override
  _CheriDetailViewScreenState createState() => _CheriDetailViewScreenState();
}

class _CheriDetailViewScreenState extends State<CheriDetailViewScreen> {
  ScrollController _scrollController = ScrollController();
  late double height;
  late double width;
  String? language;
  bool isDialogTextOpen = false;
  bool isDialogPictureOpen = false;

  bool _loaded = false;
  CheriState _cheriState = CheriState.IDLE;



  @override
  void initState() {

    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    language =  languagePreferences!.getString("language")??"en";
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final  args = ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    String cheriId = args["cheriId"]!;
    String memberId = args["memberId"]!;




    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (Navigator.of(context).userGestureInProgress)
            return false;
          else
            return true;
        },
        child: SafeArea(child: Consumer<DetailedViewProvider>(builder: (context, detailedProvider, child) {
          if (!_loaded) {
            detailedProvider.fetchDetailedViewData(cheriId, memberId).then((value) {});
            _loaded = true;
          }
          return CustomScrollView(
            controller: _scrollController,
            slivers: [_buildSliverAppBar(height, detailedProvider), _buildList(detailedProvider, width, memberId, cheriId)],
          );
        })),
      ),
    );
  }

  Widget _buildSliverAppBar(double height, DetailedViewProvider detailedViewProvider) {
    return SliverAppBar(
      shadowColor: Colors.blue,
      elevation: 5,
      centerTitle: true,
      shape: Border(bottom: BorderSide(color: Colors.black, width: 0.5)),
      floating: true,
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      title: Text(
        (detailedViewProvider.detailedPost.title != null ? detailedViewProvider.detailedPost.title : "")!,
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      leading: IconButton(
        icon: Icon(

          Icons.arrow_back_sharp,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context, _cheriState);
        },
      ),
    );
  }

  Widget _buildList(DetailedViewProvider detailedViewProvider, double width, String memberId, String cheriId) {
    return SliverToBoxAdapter(
        child: ListView.separated(
          padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      itemCount: detailedViewProvider.items.length + 2,
      itemBuilder: (BuildContext context, index) {
        if (index == 0)
          return _buildIntroWidget(detailedViewProvider);
        else if (index == 1)
          return _buildAccountWidget(detailedViewProvider, memberId, cheriId, width);
        else {
          index = index - 2;

          return _buildCheckListWidget(index, detailedViewProvider.items, detailedViewProvider, memberId, cheriId);
        }
      },
      separatorBuilder: (context, index) {
            if(index != 0)
        return Divider(

          color: Colors.black,
        );
            return Container();
      },
    ));
  }

  Widget _buildIntroWidget(DetailedViewProvider detailedViewProvider) {
    return Container(
      decoration: BoxDecoration(
        border: Border(

          bottom: BorderSide(width: 1.0, color: Colors.black),
        ),
        color: Theme.of(context).primaryColorDark,
        image: detailedViewProvider.detailedPost.pictureId != null
            ? DecorationImage(
                image: NetworkImage(
                  "https://cheri.weeknday.com${detailedViewProvider.detailedPost.pictureId}",
                ),
          colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),

          fit: BoxFit.cover,
              )
            : DecorationImage(
                image: AssetImage("assets/images/placeholder.png"),
          colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),

          fit: BoxFit.cover,
              ),
      ),
      height: 185,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 25,
            width: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Text(
              (detailedViewProvider.detailedPost.categoryName != null ? detailedViewProvider.detailedPost.categoryName : "")!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          Container(
            child: detailedViewProvider.detailedPost.title != null
                ? Text(
                    detailedViewProvider.detailedPost.title!,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                : Center(

                    child:

                    CircularProgressIndicator(
                      color: Theme.of(context).selectedRowColor,

                    )
                  ),
          ),
          Container(
            child: Text(
              "${detailedViewProvider.detailedPost.regDate != null ? detailedViewProvider.detailedPost.regDate : ""}  ${cheriViews[language]} ${detailedViewProvider.detailedPost.views != null ? detailedViewProvider.detailedPost.views : ""}",
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAccountWidget(DetailedViewProvider detailedViewProvider, String memberId, String cheriId, double width) {
    List<String> hashtags =detailedViewProvider.detailedPost.hashTag!=null? detailedViewProvider.detailedPost.hashTag!.split(","):[];
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.account_circle,
                  size: 30,
                ),
                onPressed: () {},
              ),
              Text(
                (detailedViewProvider.detailedPost.nickName != null ? detailedViewProvider.detailedPost.nickName : "")!,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ],
          ),
          if (detailedViewProvider.detailedPost.comment != null)
            Row(
              children: [
                Container(
                  width: 50,
                ),
                Container(
                  width: 0.8 * width,
                  child: Text(
                    detailedViewProvider.detailedPost.comment!,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          if (hashtags.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                   alignment: WrapAlignment.spaceEvenly,
                  children: List.generate(hashtags.length, (index) {
                    if(index == 0)
                      return Container(
                        width: 50,
                      );
                    else {
                      index = index - 1;
                     return Container(
                          margin: EdgeInsets.only(left: 10),
                         child: InkWell(
                           onTap: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(height, width, hashtags[index])));
                           },
                           child: Text("#${hashtags[index]}",style: TextStyle(
                             color: Colors.blue,
                             fontSize: 15
                           ),),
                         ));}
                  })
                ),
              ),
            ),
          if(memberId != "")
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (detailedViewProvider.detailedPost.saveYn == "Y") {
                          detailedViewProvider.saveCheriPost(detailedViewProvider.detailedPost.cherId, "N", memberId).then((value) {
                            if (value) {
                              detailedViewProvider.fetchDetailedViewData(
                                  cheriId, memberId).then((value) {
                                    if(value)
                                      setState(() {
                                        _cheriState = CheriState.UNSAVED;
                                        showToast(bookMarkUnsave[language]!);

                                      });
                              });
                            }
                          });
                        } else {
                          detailedViewProvider.saveCheriPost(detailedViewProvider.detailedPost.cherId, "Y", memberId).then((value) {
                            if (value) detailedViewProvider.fetchDetailedViewData(cheriId, memberId).then((value) {
                              if(value)
                                setState(() {
                                  _cheriState = CheriState.SAVED;
                                  showToast(bookmarkSave[language]!);

                                });
                            });
                          });
                        }
                      },
                      icon: detailedViewProvider.detailedPost.saveYn == "Y"
                          ? Icon(
                              Icons.bookmark,
                              size: 30,
                            )
                          : Icon(
                              Icons.bookmark_border,
                              size: 30,
                            ),
                    ),
                    Text(
                      "${bookMarkNumber[language]}",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Share.share('https://cheri.weeknday.com/search?id=${detailedViewProvider.postsResponse.encryptedId}');
                      },
                      icon: Icon(
                        Icons.share_outlined,
                        size: 30,
                      ),
                    ),
                    Text(
                      "${shareNumber[language]}",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckListWidget(int index, List<Item> items, DetailedViewProvider detailedViewProvider, String memberId, String cheriId) {
    return Container(
      child: Row(
        children: [
          if(memberId != "")
           Checkbox(
              side: BorderSide(
                color: Theme.of(context).selectedRowColor,
                style: BorderStyle.solid
              ),

                activeColor: Colors.transparent,


                checkColor: Theme.of(context).selectedRowColor,
                value: items[index].checkedYn == "Y" ? true : false,
                onChanged: (bool? value) {
                  String checked = (value == true) ? "Y" : "N";

                  detailedViewProvider.updateCheckListItem(items[index].itemId!, checked, memberId, detailedViewProvider.detailedPost.cherId??"").then((value) {
                    if (value) {
                      detailedViewProvider.fetchDetailedViewData(cheriId, memberId).then((value) {
                        if (value) print("saved!");
                      });
                    }
                  });
                }),

          Expanded(
            flex: 4,
            child: Container(
              margin: memberId != ""? EdgeInsets.only(left: 0):EdgeInsets.only(left: 10),
              child: Text(
                items[index].contents!,
                maxLines: 5,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if ((items[index].comment != null && items[index].comment!.isNotEmpty) || (detailedViewProvider.itemFiles(items[index].itemId!).isNotEmpty))
            IconButton(
              onPressed: () async {
                if (items[index].comment == null || items[index].comment!.isEmpty) {
                  print("1");
                  await showdialog(context, "${noContent[language]}", detailedViewProvider.itemFiles(items[index].itemId!)[0].saveFileName);
                } else if (detailedViewProvider.itemFiles(items[index].itemId!).isEmpty) {
                  print("2");

                  await showdialog(context, items[index].comment!, placeholdeUrl);
                } else {
                  print("3");

                  await showdialog(context, items[index].comment!, detailedViewProvider.itemFiles(items[index].itemId!)[0].saveFileName);
                }
              },
              icon: Icon(Icons.article_outlined),
            )
        ],
      ),
    );
  }

  Future<void> showdialog(BuildContext context, String contents, String saveFileName) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            insetPadding: EdgeInsets.all(10),
            child: Container(
              height: 500,
              child: Scrollbar(
                thickness: 5,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${dialogViewIntroduction[language]}",
                                style: TextStyle(fontSize: 21),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    Navigator.pop(context,  _cheriState);
                                  }),
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${dialogCategoryIntroduction[language]}",
                              style: TextStyle(fontSize: 15),
                            ),
                            IconButton(
                                icon: isDialogTextOpen ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
                                onPressed: () {
                                  setState(() {
                                    isDialogTextOpen = !isDialogTextOpen;
                                  });
                                })
                          ],
                        ),
                      ),
                      Container(decoration: BoxDecoration(color: Color.fromRGBO(245, 245, 245, 1), borderRadius: BorderRadius.all(Radius.circular(8))), padding: EdgeInsets.all(10), margin: EdgeInsets.only(left: 10, right: 10), child: Text(contents)),
                      Divider(),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${dialogRelatedContent[language]}",
                              style: TextStyle(fontSize: 15),
                            ),
                            IconButton(
                                icon: isDialogPictureOpen ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
                                onPressed: () {
                                  setState(() {
                                    isDialogPictureOpen = !isDialogPictureOpen;
                                  });
                                })
                          ],
                        ),
                      ),
                      Container(margin: EdgeInsets.all(10), child: saveFileName != placeholdeUrl ? Image.network("https://cheri.weeknday.com/upload/detailfile/${saveFileName}") : Image.network(placeholdeUrl)),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }



}
