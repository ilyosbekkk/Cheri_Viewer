import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:viewerapp/utils/utils.dart';
import 'package:viewerapp/utils/strings.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/business_logic/providers/cheri provider.dart';

// ignore: must_be_immutable
class ListViewWidget extends StatelessWidget {

  double height;
  double width;
  Post post;

  ListViewWidget(this.height, this.width,  this.post);

  @override
  Widget build(BuildContext context) {
    return  Consumer<CheriProvider>(builder: (context, cheriProvider,  child){
      return  Container(

        margin: EdgeInsets.only(top: 10.0),

        height: 110,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 16, right: 10 , top: 10, bottom: 5.0),
              width: 101,
              height: 100,

              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover
                    ,
                    image: NetworkImage(post.imgUrl),
                  )
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 20,
                  width: 70,
                  margin: EdgeInsets.only(top: 10.0),
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
                Container(
                  width: width*0.5,
                  margin: EdgeInsets.only( top: 10.0),
                  child: Text(
                    post.title,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(
                    post.author,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Row(
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

              ],
            ),
            Spacer(),
            Container(

              width: 30,
              height: 30,
              margin: EdgeInsets.only( right: 8, top: 10),
              color: Theme.of(context).primaryColorDark,
              child: post.shareYN == "N"
                  ? InkWell(
                onTap: () {
                  cheriProvider.save(post);
                },
                child: Icon(

                  Icons.bookmark_border,
                  color: Theme.of(context).backgroundColor,
                ),
              )
                  : InkWell(
                onTap: () {
                  cheriProvider.unsave(post);
                },
                child: Icon(Icons.bookmark, color: Theme.of(context).backgroundColor),
              ),
            ),
          ],
        ),
      );
    });
  }
}
