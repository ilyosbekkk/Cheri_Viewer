import 'package:flutter/material.dart';

import '../../utils/Strings.dart';



class SearchScreen extends StatefulWidget {


  double height;
  double  width;
   SearchScreen(this.height, this.width);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}



class _SearchScreenState extends State<SearchScreen> {

 @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only( left: widget.width * 0.025, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 9,
                child: Container(
                  height: widget.height*0.05,
                  child: TextField(
                    autofocus: true,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10.0),
                      hintText: hint_text,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: MaterialButton(onPressed: () {

                }, child: const Text("츼소")),
              )
            ],
          ),
        ],
      ),
    );
  }
}
