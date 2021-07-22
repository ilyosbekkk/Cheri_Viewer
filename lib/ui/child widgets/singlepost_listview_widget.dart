import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/ui/screens/cheri_detail_screen.dart';
import 'package:viewerapp/utils/utils.dart';
import 'package:viewerapp/utils/strings.dart';
import 'package:viewerapp/business_logic/providers/cheri provider.dart';

class ListViewWidget extends StatefulWidget {

  double  height;
  double   width;
  Post post;

  ListViewWidget(this.height, this.width,  this.post);

  @override
  _ListViewWidgetState createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  late String  memberId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    memberId = preferences!.getString("id")??"";
  }
  @override
  Widget build(BuildContext context) {
    return  Consumer<CheriProvider>(builder: (context, cheriProvider,  child){
      return  InkWell(
        onTap: () {

            Navigator.pushNamed(context, CheriDetailViewScreen.route, arguments: {"cheriId": widget.post.cheriId, "memberId": memberId}).then((value) {
              if(value == CheriState.SAVED) {
                widget.post.saved = "Y";
              }
              else if(value == CheriState.UNSAVED) {
                widget.post.saved = "N";
              }
              setState(() {});

            });
            print(widget.post.cheriId);


        },
        child: Container(
          margin: EdgeInsets.only(top: 10.0),
          height: 110,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 0.5),
            )
          ),
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
                      image: NetworkImage(widget.post.imgUrl),
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
                      widget.post.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: widget.width*0.5,
                    margin: EdgeInsets.only( top: 10.0),
                    child: Text(
                      widget.post.title,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text(
                      widget.post.author,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "${cheri_views[korean]}:${widget.post.views}",
                        style: TextStyle(fontSize: 12),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 3.0, right: 3.0),
                          child: Icon(
                            Icons.circle,
                            size: 5.0,
                          )),
                      Text(
                        "${timeFormatter(widget.post.dateTime)} 전",
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
                child: widget.post.saved == "N"
                    ? InkWell(
                  onTap: () {
                    if(memberId != null)
                      cheriProvider.saveCheriPost(widget.post.cheriId, "Y", memberId).then((value)  {
                        if(value)
                          setState(() {
                            widget.post.saved = "Y";
                            showToast(bookmarkSave[english]!);

                          });
                      });
                    else showToast(toastSignIn[korean]!);
                    },
                  child: Icon(

                    Icons.bookmark_border,
                    color: Theme.of(context).backgroundColor,


                  ),
                )
                    : InkWell(
                  onTap: () {
                    if(memberId != null)
                      cheriProvider.saveCheriPost(widget.post.cheriId, "N", memberId).then((value){
                        if(value) {
                          setState(() {
                            widget.post.saved = "N";
                            showToast(bookMarkUnsave[english]!);
                          });
                        }
                      });
                    else showToast(toastSignIn[korean]!);
                  },
                  child: Icon(Icons.bookmark, color: Theme.of(context).backgroundColor,),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
