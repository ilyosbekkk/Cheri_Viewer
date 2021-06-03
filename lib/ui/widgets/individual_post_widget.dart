import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/business_logic/providers/home_provider.dart';

import '../../models/post_model.dart';

class PostWidget extends StatelessWidget {
  double height;
  double width;
  Post individual_post;

  PostWidget(this.height, this.width, this.individual_post);

  @override
  Widget build(BuildContext context) {
    var post = Provider.of<PostProvider>(context, listen: true);
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
      height: height,
      width: width,
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
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/logo.png',
                        image: individual_post.imgUrl,
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
                          child: !individual_post.like
                              ? IconButton(
                                  icon: Icon(
                                    Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    post.like(individual_post);
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    size: 25.0,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    post.unLike(individual_post);
                                    },
                                ),
                        )
                      ],
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(left: 10.0, top: 5.0),
              child: Text(
                individual_post.title,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0, top: 5.0),
              child: Text(
                individual_post.author,
                style: TextStyle(fontSize: 15),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0, top: 5.0),
              child: Row(
                children: [
                  Text(
                    "Views:${individual_post.views}",
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 3.0, right: 3.0),
                      child: Icon(
                        Icons.circle,
                        size: 5.0,
                      )),
                  Text(
                    "${individual_post.dateTime} hours ago",
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
