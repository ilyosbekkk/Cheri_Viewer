import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/providers/cheri%20%20individual%20post%20%20provider.dart';
import 'package:viewerapp/providers/saved%20posts%20screen%20provider.dart';

import 'package:viewerapp/providers/user%20management%20provider.dart';
import 'package:viewerapp/ui/auth_screen.dart';
import 'package:viewerapp/utils/strings.dart';
import 'package:viewerapp/utils/utils.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/ui/cheri_detail_screen.dart';

import '../categoryview_screen.dart';

class CardViewWidget extends StatefulWidget {
  double height;
  double width;
  Post post;
  CardViewWidget(this.height, this.width,  this.post);

  @override
  _CardViewWidgetState createState() => _CardViewWidgetState();
}

class _CardViewWidgetState extends State<CardViewWidget> {

  UserManagementProvider _userManagementProvider = UserManagementProvider();
  String? language;
  late String memberId;
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
     language = languagePreferences!.getString("language")??"ko";
     var provider = Provider.of<CollectionsProvider>(context, listen: false);
     _userManagementProvider = Provider.of<UserManagementProvider>(context, listen: true);

     memberId = _userManagementProvider.userId??"";

    return Consumer<CheriProvider>(builder: (context,  cheriProvider,  child) {
      return  Container(
        margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
        height: 320,
        width: double.infinity,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, CheriDetailViewScreen.route, arguments: {"cheriId": widget.post.cheriId, "memberId": memberId}).then((value) {
                if(value == CheriState.SAVED) {
                   provider.savedPosts.add(widget.post);
                  widget.post.saved = "Y";
                }
                else if(value == CheriState.UNSAVED) {
                  provider.savedPosts.removeWhere((element) => element.cheriId == widget.post.cheriId);
                  widget.post.saved = "N";
                }
                setState(() {
                });
            });
            },
          child: Card(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 206,
                    width: widget.width,
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)
                          ),
                          child: FadeInImage.assetNetwork(
                            imageErrorBuilder: (context, error, stackTrace) => Image.asset('assets/images/placeholder.png'),
                            placeholder: 'assets/images/placeholder.png',
                            image: widget.post.imgUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, CategoryViewScreen.route, arguments: {"id":widget.post.categoryId, "title": widget.post.category});
                                },
                              child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: 130,
                                margin: EdgeInsets.only(top: 16.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                child: Text(
                                  widget.post.category,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),





                            Container(
                                alignment: Alignment.center,
                                width: 30,
                                height: 30,
                                margin: EdgeInsets.only(top: 16.0, right: 8),
                                color: Theme.of(context).primaryColorDark,
                                child: widget.post.saved == "N"
                                    ?
                                InkWell(
                                  onTap: ()  {
                                    if(memberId != "")
                                      cheriProvider.saveCheriPost(widget.post.cheriId, "Y", memberId).then((value)  {
                                        if(value)
                                          setState(() {
                                            provider.savedPosts.add(widget.post);
                                            widget.post.saved = "Y";
                                            showToast(bookmarkSave[language]!);

                                          });
                                      });
                                    else {
                                      Navigator.pushNamed(context, AuthScreen.route);
                                    }
                                  },
                                  child: Icon(
                                    Icons.bookmark_border,
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                )
                                    : InkWell(
                                  onTap: () async {
                                    if(memberId != "")
                                      cheriProvider.saveCheriPost(widget.post.cheriId, "N", memberId!).then((value){
                                        if(value) {
                                          setState(() {
                                            provider.savedPosts.removeWhere((element) => element.cheriId == widget.post.cheriId);
                                            widget.post.saved = "N";
                                            showToast(bookMarkUnsave[language]!);
                                          });


                                        }
                                      });
                                    else {
                                      Navigator.pushNamed(context, AuthScreen.route);
                                    }
                                  },
                                  child: Icon(Icons.bookmark, color: Theme.of(context).backgroundColor),
                                ),
                              )
                           ,


                          ],
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(left: 10.0, top: 15.0),
                  child: Text(
                    widget.post.title,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0, top: 10.0),
                  child: Row(
                    children: [
                      Text(
                        widget.post.author,
                        style: TextStyle(fontSize: 12),
                      ),
                      Spacer(),

                      if(widget.post.checked == "Y")
                      Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Icon(Icons.check_box_outlined, color: Theme.of(context).selectedRowColor, size: 30,))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Row(
                    children: [
                      Text(
                        "${cheriViews[language]} ${widget.post.views}",
                        style: TextStyle(fontSize: 12),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 3.0, right: 3.0),
                          child: Icon(
                            Icons.circle,
                            size: 5.0,
                          )),
                      Text(
                        "${timeFormatter(widget.post.dateTime, language!)}",
                        style: TextStyle(fontSize: 12),
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
