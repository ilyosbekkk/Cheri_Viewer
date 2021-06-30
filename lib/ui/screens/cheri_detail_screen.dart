import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:viewerapp/business_logic/providers/detailedview_provider.dart';
import 'package:viewerapp/utils/strings.dart';

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
          // detailedProvider.fetchDetailedViewItemsList(cheriId, memberId).then((value) {});
          // detailedProvider.fetchDetailedViewFilesList(cheriId).then((value) {});
          _loaded = true;
        }

        return CustomScrollView(
          controller: _scrollController,
          slivers: [_buildSliverAppBar(height, detailedProvider), _buildList(detailedProvider, width)],
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
        detailedViewProvider.detailedPost.title!,
        style: TextStyle(
          fontSize: 18,
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

  Widget _buildList(DetailedViewProvider detailedViewProvider, double width) {
    return SliverToBoxAdapter(
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemCount: 15,
        itemBuilder: (BuildContext context, index) {
          if (index == 0)
            return _buildIntroWidget(detailedViewProvider);

          else if(index  == 1)
            return _buildAccountWidget(detailedViewProvider,  width);
           else
            return _buildCheckListWidget(index);
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
        image: DecorationImage(
          image: NetworkImage("https://cheri.weeknday.com${detailedViewProvider.detailedPost.pictureId}"),
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
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.all(	Radius.circular(5))
            ),
            child: Text(
              detailedViewProvider.detailedPost.categoryName!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white
              ),
            ),

          ),
          Container(
            child: Text(detailedViewProvider.detailedPost.title!, style: TextStyle(
              fontSize: 20,
              color: Colors.white
            ),),
          ),
          Container(child: Text("${detailedViewProvider.detailedPost.regDate}  ${cheri_views[korean]} ${detailedViewProvider.detailedPost.views}", style: TextStyle(
            fontSize: 12, color: Colors.white
          ),),)
        ],
      ),
    );
  }

  Widget _buildAccountWidget(DetailedViewProvider detailedViewProvider,  double width) {
    return Container(
      height: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(icon: Icon(Icons.account_circle,  size: 30,), onPressed: () {}, ),
              Text(detailedViewProvider.detailedPost.nickName!, style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold
              ),)
            ],
          ),
          Row(
            children: [
            Container( width: 50,),
              Container(
                width: 0.8*width,
                child: Text(
                  detailedViewProvider.detailedPost.comment == null?"내용이 없습니다": detailedViewProvider.detailedPost.comment! ,
                  style: TextStyle(
                      fontSize: 15
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
            Container( width: 50,),
              Container(
                width: 0.8*width,
                child: Text(
                  (detailedViewProvider.detailedPost.hashTag == null  ?"내용이 없습니다":detailedViewProvider.detailedPost.hashTag)!,
                  style: TextStyle(
                    color: Colors.blue,
                      fontSize: 15
                  ),
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
                      onPressed: () {},
                      icon: Icon(Icons.bookmark_border,  size: 30,),
                    ),
                    Text("북마크", style: TextStyle(fontSize: 12),)
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Share.share('check out my website https://example.com');
                      },
                      icon: Icon(Icons.share_outlined, size: 30,),
                    ),
                    Text("공유", style: TextStyle(fontSize: 12),)

                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }



  Widget _buildCheckListWidget(int index) {
    return Container(
      height: 0.04 * height,
      child: Row(
        children: [
          Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              }),
          Text(" 외관 – 와이퍼 위치 확인->$index"),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.event_note_sharp),
          )
        ],
      ),
    );
  }
}
