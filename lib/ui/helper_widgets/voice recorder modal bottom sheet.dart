import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/business_logic/providers/search%20provider.dart';

class VoiceRecorderModalBottomSheet extends StatelessWidget {
  double height;
  bool _initialized = false;
  String _searchWord;

  VoiceRecorderModalBottomSheet(this.height, this._searchWord);

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, search, child) {
      if (!_initialized) {
        search.initSpeechState().then((value) {
          if (search.has_speech || !search.speech.isListening) search.startListening(context);
        });
        _initialized = true;
      }

      if (search.word1.isNotEmpty && search.word1 != "") {
        Navigator.pop(context, search.word1);
      }

      return Container(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              child: Text("Recognized words:  ${search.word1}"),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Text(
                "듣고 있습니다...말씀하세요 🙂",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        if (search.speech.isListening) search.stopListening();
                      },
                      child: Text("Stop")),
                  TextButton(
                      onPressed: () {
                        if (search.speech.isListening) search.cancelListening();
                      },
                      child: Text("Cancel")),
                ],
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
    });
  }
}
