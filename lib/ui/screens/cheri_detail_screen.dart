import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../../utils/strings.dart';

class CheriDetailViewScreen extends StatefulWidget {
  static String route = "/cheridetail_screen";

  const CheriDetailViewScreen();

  @override
  _CheriDetailViewScreenState createState() => _CheriDetailViewScreenState();
}

class _CheriDetailViewScreenState extends State<CheriDetailViewScreen> {
  ScrollController _scrollController = ScrollController();
  late double _appBarHeight;
  late double height;
  late double width;
  bool  isChecked = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [_buildSliverAppBar(height), _buildList()],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(double height) {
    AppBar appBar = AppBar(
      title: Text('Demo'),
    );
    setState(() {
      _appBarHeight = appBar.preferredSize.height;
    });

    return SliverAppBar(
      shadowColor: Colors.blue,
      elevation: 5,
      centerTitle: true,
      shape: Border(bottom: BorderSide(color: Colors.black, width: 0.5)),
      floating: true,
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      title: Text(
        "TEMP TITLE",
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

  Widget _buildList() {
    return SliverToBoxAdapter(
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemCount: 15,
        itemBuilder: (BuildContext context, index) {
          if (index == 0)
            return _buildIntroWidget();
          else if (index == 1)
            return _buildAccountWidget();
          else if (index == 2)
            return  _buildExtraWidgets();
          else if(index == 3)
            return Center(child: Text("Your checklist:",  style: TextStyle(
              fontSize: 18
            ),));
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
  Widget _buildIntroWidget() {
    return Container(

      margin: EdgeInsets.only(top: 10),
      height: height * 0.2,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text("2020.09.20 "),
                Icon(
                  Icons.circle,
                  size: 5,
                ),
                Text(" 조회수 243 "),
                Icon(
                  Icons.circle,
                  size: 5,
                ),
                Text(
                  " 23",
                  textAlign: TextAlign.center,
                ),
                Icon(Icons.bookmark)
              ],
            ),
          ),
          Expanded(
              child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "식단관리",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "신차인수 체크리스트",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
  Widget _buildAccountWidget() {
    return Container(
        height: height * 0.15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center ,

                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor:Colors.black38.withOpacity(0),
                    backgroundImage: AssetImage("assets/images/account.png"),
                  ),
                  Text("김승규", style: TextStyle(fontSize: 18),)
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: width*0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center ,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("신차 구입시, 확인 해봐야하는 꿀팁입니다 신차 구입시, 확인 해봐야하는 꿀팁입니다 신차 구입시, 확인 해봐야하는 꿀팁입니다 ", maxLines: 3, style: TextStyle(
                    fontSize: 15
                  ),),
                  Text("#안녕 #한국 #미국 #호주 #소주", maxLines: 3, style: TextStyle(
                    fontSize: 15,
                    color: Colors.lightBlue
                  ),),
                ],
              ),
            ),

          ],
        ));
  }
  Widget _buildExtraWidgets() {
    return Container(
      height: height*0.05,
      child: Row(
      children: [
        IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_border),),
        IconButton(onPressed: () {
          Share.share('check out my website https://example.com');
        }, icon: Icon(Icons.share_outlined),),
      ],
      ),
    );
  }
  Widget _buildCheckListWidget(int index ) {
   return  Container(

      height: 0.04*height,
      child: Row(
        children: [
          Checkbox(value: isChecked, onChanged: (bool? value) {
            setState(() {
              isChecked = value!;
            });
          }),
          Text(" 외관 – 와이퍼 위치 확인->${index}"),
          Spacer(),
          IconButton(onPressed: () {},  icon: Icon(Icons.event_note_sharp),)
        ],
      ) ,
    );
  }
}
