import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viewerapp/business_logic/providers/search%20provider.dart';

class VoiceRecorderModalBottomSheet extends StatelessWidget {
  double height;

  VoiceRecorderModalBottomSheet(this.height);

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, search, child) {
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
              child: Text("Recognized words:  ${search.word1}"),),
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
                        if (search.has_speech || !search.speech.isListening) search.startListening();
                      },
                      child: Text("Start")),
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
              child: Row(
              children: [
                DropdownButton(
                    onChanged: (selectedValue) => search.switchLang(selectedValue),
                    value: search.currentLocaleId,
                    items: search.localeNames.map((e) => DropdownMenuItem(child: Text(e.name),  value: e.localeId,)).toList())
              ],
            ),),

            Container(
                decoration: BoxDecoration(color: Colors.red, border: Border.all(color: Colors.red), borderRadius: BorderRadius.all(Radius.circular(30))),
                margin: EdgeInsets.only(bottom: 30),
                child: IconButton(
                    icon: Icon(
                      Icons.mic_sharp,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () async {
                      if (!search.has_speech) await search.initSpeechState();
                    }))
          ],
        ),
      );
    });
  }
}
