import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/utils/strings.dart';
import 'package:viewerapp/utils/utils.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/ui/screens/cheri_detail_screen.dart';
import 'package:viewerapp/business_logic/providers/cheri provider.dart';

class CardViewWidget extends StatelessWidget {
  double height;
  double width;
  Post post;



  CardViewWidget(this.height, this.width,  this.post);

  @override
  Widget build(BuildContext context) {
    String? memberId = (preferences!.getString("id") ?? null);
    return Consumer<CheriProvider>(builder: (context,  cheriProvider,  child) {
      return  Container(
        margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
        height: 310,
        width: double.infinity,
        child: InkWell(
          onTap: () {
            if(memberId != null) {
              Navigator.pushNamed(context, CheriDetailViewScreen.route, arguments: {"cheriId": post.cheriId, "memberId": memberId});
              print(post.cheriId);
            }
            else {
              print("Please login");
            }
          },
          child: Card(
            elevation: 10.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 206,
                    width: width,
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        ClipRRect(
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/placeholder.png',
                            image: post.imgUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                // Navigator.pushNamed(context, CategoryViewScreen.route, arguments: {"id": post.categoryId, "title": post.category});
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
                                  post.category,
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
                              child: post.shareYN == "N"
                                  ? InkWell(
                                onTap: ()  async{
                                  cheriProvider.saveCheriPost(post.cheriId, "Y", memberId!);
                                },
                                child: Icon(
                                  Icons.bookmark_border,
                                  color: Theme.of(context).backgroundColor,
                                ),
                              )
                                  : InkWell(
                                onTap: () async {
                                  cheriProvider.saveCheriPost(post.cheriId, "N", memberId!);
                                  },
                                child: Icon(Icons.bookmark, color: Theme.of(context).backgroundColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(left: 10.0, top: 15.0),
                  child: Text(
                    post.title,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0, top: 10.0),
                  child: Text(
                    post.author,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Row(
                    children: [
                      Text(
                        "${cheri_views[korean]}:${post.views}",
                        style: TextStyle(fontSize: 12),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 3.0, right: 3.0),
                          child: Icon(
                            Icons.circle,
                            size: 5.0,
                          )),
                      Text(
                        "${timeFormatter(post.dateTime)} 전",
                        style: TextStyle(fontSize: 12),
                      )
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
