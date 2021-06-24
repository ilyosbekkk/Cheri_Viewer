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

  PostWidget(this.height, this.width,  this.homePageProvider, this.post);



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
      height: height,
      width: double.infinity,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CheriDetailViewScreen()),
          );
        },
        child: Card(
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
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
                        borderRadius: BorderRadius.circular(15.0),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder.png',
                          image:post.imgUrl,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: width * 0.2,
                            margin: EdgeInsets.only(left: 10.0, top: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                border: Border.all(color: Colors.white),
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                            child: Text(
                              "구매.판매",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            child: !post.like
                                ? IconButton(
                              icon: Icon(
                                Icons.bookmark_border,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                homePageProvider.bookmark(post);
                              },
                            )
                                : IconButton(
                              icon: Icon(
                                Icons.bookmark,
                                size: 25.0,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                homePageProvider
                                    .unbookmark(post);
                              },
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
                      "$views_kr:${post.views}",
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
    );;
  }
}
