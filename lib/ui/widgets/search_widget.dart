import 'package:flutter/material.dart';

import '../../utils/Strings.dart';

class SearchWidget extends StatelessWidget {
  TextEditingController _controller = TextEditingController();
  double height;
  double width;

  SearchWidget(this.height, this.width);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only( left: width * 0.025),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150,
              decoration: BoxDecoration(
                  borderRadius:BorderRadius.all(Radius.circular(10.0)),
                  color: Color.fromRGBO(173, 216, 230, 1)
              ),

              child: Text(search_page, textAlign: TextAlign.center, style: TextStyle(
                  fontSize: 25,
                  color: Colors.white
              ),),
            ),
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Container(
                    height: height*0.05,
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
      ),
    );
  }
}
