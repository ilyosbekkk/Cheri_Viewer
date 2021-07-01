import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:viewerapp/business_logic/providers/detailedview_provider.dart';
import 'package:viewerapp/models/postitem_model.dart';
import 'package:viewerapp/utils/strings.dart';
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
  late bool _loaded = false;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    String cheriId = args["cheriId"]!;
    String memberId = args["memberId"]!;

    return Scaffold(
      body: SafeArea(child: Consumer<DetailedViewProvider>(builder: (context, detailedProvider, child) {
        if (!_loaded) {
          detailedProvider.fetchDetailedViewData(cheriId, memberId).then((value) {});
          detailedProvider.fetchDetailedViewItemsList(cheriId, memberId).then((value) {});

          _loaded = true;
        }

        return CustomScrollView(
          controller: _scrollController,
          slivers: [_buildSliverAppBar(height, detailedProvider), _buildList(detailedProvider, width, memberId, cheriId)],
        );
      })),
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
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildList(DetailedViewProvider detailedViewProvider, double width, String memberId, String cheriId) {
    return SliverToBoxAdapter(
      child: ListView.separated(
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
          return Divider(
            color: Colors.black,
          );
        },
      ),
    );
  }

  Widget _buildIntroWidget(DetailedViewProvider detailedViewProvider) {
    return Container(
      // color: Theme.of(context).primaryColorDark,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        image: detailedViewProvider.detailedPost.pictureId != null
            ? DecorationImage(
                image: NetworkImage("https://cheri.weeknday.com${detailedViewProvider.detailedPost.pictureId}"),
                fit: BoxFit.cover,
              )
            : DecorationImage(
                image: AssetImage("assets/images/placeholder.png"),
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
                : CircularProgressIndicator(
                    backgroundColor: Theme.of(context).selectedRowColor,
                  ),
          ),
          Container(
            child: Text(
              "${detailedViewProvider.detailedPost.regDate != null ? detailedViewProvider.detailedPost.regDate : ""}  ${cheri_views[korean]} ${detailedViewProvider.detailedPost.views != null ? detailedViewProvider.detailedPost.views : ""}",
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAccountWidget(DetailedViewProvider detailedViewProvider, String memberId, String cheriId, double width) {
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
          if (detailedViewProvider.detailedPost.hashTag != null)
            Row(
              children: [
                Container(
                  width: 50,
                ),
                Container(
                  width: 0.8 * width,
                  child: Text(
                    (detailedViewProvider.detailedPost.hashTag)!,
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
              ],
            ),
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
                            if (value) detailedViewProvider.fetchDetailedViewData(cheriId, memberId).then((value) {});
                          });
                        } else {
                          detailedViewProvider.saveCheriPost(detailedViewProvider.detailedPost.cherId, "Y", memberId).then((value) {
                            if (value) detailedViewProvider.fetchDetailedViewData(cheriId, memberId).then((value) {});
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
                      "북마크",
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
                      "공유",
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
          Checkbox(
              value: items[index].checkedYn == "Y" ? true : false,
              onChanged: (bool? value) {
                String checked = (value == true) ? "Y" : "N";
                detailedViewProvider.updateCheckListItem(items[index].itemId!, checked, memberId).then((value) {
                  if (value) {
                    detailedViewProvider.fetchDetailedViewItemsList(cheriId, memberId).then((value) {
                      if (value) print("saved!");
                    });
                  }
                });
              }),
          Expanded(
            flex: 4,
            child: Container(
              child: Text(
                items[index].contents!,
                maxLines: 5,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            onPressed: ()  async{

             await showDialog(context: context, builder: (BuildContext context) {
                return new AlertDialog(
                  title: new Text("My Super title"),
                  content: new Text("Hello World"),
                );
              });

             },
            icon: Icon(Icons.article_outlined),
          )
        ],
      ),
    );
  }
}
