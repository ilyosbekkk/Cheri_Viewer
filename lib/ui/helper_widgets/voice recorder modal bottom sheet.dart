import 'package:flutter/material.dart';

class VoiceRecorderModalBottomSheet extends StatelessWidget {
  double height;

  VoiceRecorderModalBottomSheet(this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(
              "듣고 있습니다...말씀하세요 🙂",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
              decoration: BoxDecoration(color: Colors.red, border: Border.all(color: Colors.red), borderRadius: BorderRadius.all(Radius.circular(30))),
              margin: EdgeInsets.only(bottom: 30),
              child: IconButton(
                  icon: Icon(
                    Icons.mic_sharp,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {}))
        ],
      ),
    );
  }
}
