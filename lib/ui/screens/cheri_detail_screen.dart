import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:viewerapp/business_logic/providers/detailedview_provider.dart';
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
          // detailedProvider.fetchDetailedViewItemsList(cheriId, memberId).then((value) {});
          // detailedProvider.fetchDetailedViewFilesList(cheriId).then((value) {});
          _loaded = true;
        }

        return CustomScrollView(
          controller: _scrollController,
          slivers: [_buildSliverAppBar(height), _buildList()],
        );
      })),
    );
  }

  Widget _buildSliverAppBar(double height) {
    AppBar appBar = AppBar(
      title: Text('Demo'),
    );

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
            return _buildExtraWidgets();
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
    return Container();
  }

  Widget _buildAccountWidget() {
    return Container();
  }

  Widget _buildExtraWidgets() {
    return Container(
      height: height * 0.05,
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.bookmark_border),
          ),
          IconButton(
            onPressed: () {
              Share.share('check out my website https://example.com');
            },
            icon: Icon(Icons.share_outlined),
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
          Text(" 외관 – 와이퍼 위치 확인->${index}"),
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
