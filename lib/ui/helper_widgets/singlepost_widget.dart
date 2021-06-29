import 'package:flutter/material.dart';
import 'package:viewerapp/business_logic/providers/postslist_provider%20%20.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/ui/screens/cheri_detail_screen.dart';
import 'package:viewerapp/utils/Strings.dart';

class PostWidget extends StatelessWidget {
  double height;
  double width;
  PostListsProvider homePageProvider;
  Post post;

  PostWidget(this.height, this.width, this.homePageProvider, this.post);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
      height: height,
      width: double.infinity,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, CheriDetailViewScreen.route);
        },
        child: Card(
          elevation: 10.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: height * 0.65,
                  width: width,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      ClipRRect(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder.png',
                          image: post.imgUrl,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 130,
                            margin: EdgeInsets.only(top: 16.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorDark,
                            ),
                            child: Text(
                              "구매.판매",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 30,
                            height: 30,
                            margin: EdgeInsets.only(top: 16.0, right: 8),
                            color: Theme.of(context).primaryColorDark,
                            child: !post.like
                                ? InkWell(
                                    onTap: () {
                                      homePageProvider.save(post);
                                    },
                                    child: Icon(
                                      Icons.bookmark_border,
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      homePageProvider.unsave(post);
                                    },
                                    child: Icon(Icons.bookmark, color: Theme.of(context).backgroundColor),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(left: 10.0, top: 5.0),
                child: Text(
                  post.title,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  maxLines: 1,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, top: 5.0),
                child: Text(
                  post.author,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, top: 5.0),
                child: Row(
                  children: [
                    Text(
                      "${cheri_views[korean]}:${post.views}",
                      style: TextStyle(fontSize: 15),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 3.0, right: 3.0),
                        child: Icon(
                          Icons.circle,
                          size: 5.0,
                        )),
                    Text(
                      "${post.dateTime}",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
    ;
  }
}
