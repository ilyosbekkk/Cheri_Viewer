import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:viewerapp/utils/strings.dart';
import 'package:viewerapp/utils/utils.dart';


class VoiceRecorderModalBottomSheet extends StatefulWidget {
  final _height;

  VoiceRecorderModalBottomSheet(this._height);

  @override
  _VoiceRecorderModalBottomSheetState createState() => _VoiceRecorderModalBottomSheetState();
}

class _VoiceRecorderModalBottomSheetState extends State<VoiceRecorderModalBottomSheet> {
  bool speechAvailable = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String currentLocaleId = '';
  int resultListened = 0;
  String word1 = "";
  bool  resultAvailable = false;
  bool word2 = false;
  List<LocaleName> localeNames = [];
  final SpeechToText speech = SpeechToText();
  String? language;

  @override
  void initState() {
    super.initState();
    initSpeechState().then((value) {
      print("Initialization is complete...");
        if(speechAvailable)
            startListening().then((value) {
              print("started listening...");
            });
    });
  }
  @override
  void dispose() {
    print("Stopping method......");
    super.dispose();
    stopListening();
    word1 = "";
  }

  @override
  Widget build(BuildContext context) {
      language = languagePreferences!.getString("language")??"ko";
    if(resultAvailable){
      return Container(
        height: widget._height * 0.4,

        child: Column(

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
            Spacer(),
            Text('${voiceResult[language]}: "$word1"',  style: TextStyle(
              fontSize: 18
            ),),
            Container(
              width: 200,
              child: ElevatedButton.icon(

                icon: Icon(Icons.search),


                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).selectedRowColor),

                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),

                      )
                )),
                onPressed: () {
                  Navigator.pop(context, word1);
                },
                label: Text("${voiceSearch[language]}"),

              ),
            ),
            Container(
              width: 200,

              child: ElevatedButton.icon(
                icon: Icon(Icons.refresh),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).selectedRowColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),

                        )
                    )),
                onPressed: () async {
                  await startListening();

                  setState(() {
                    resultAvailable = false;
                    word1 = "";

                  });
                },
                label: Text("${voiceTryAgain[language]}"),

              ),
            ),
            Spacer()
          ],
        ),
      );
    }
    else
    return Container(

      height: widget._height * 0.4,
      child: Column(
        mainAxisSize: MainAxisSize.max,
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
              "${voiceMessage[language]}",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: AvatarGlow(
              duration: const Duration(milliseconds: 1000),
              repeatPauseDuration: const Duration(milliseconds: 100),
              repeat: true,
              animate: true,
              glowColor: Theme.of(context).selectedRowColor,
              endRadius: 60.0,
              child: Container(
                  child: FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {},
                child: Icon(
                  Icons.mic_none,
                  color: Colors.white,
                ),
              )),
            ),
          )
        ],
      ),
    );
  }

  Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(onError: errorListener, onStatus: statusListener, debugLogging: true, finalTimeout: Duration(milliseconds: 0), options: [SpeechToText.androidIntentLookup]);
    if (hasSpeech) {
      localeNames = await speech.locales();
      var systemLocale = await speech.systemLocale();
      currentLocaleId = systemLocale?.localeId ?? '';
    }
     print("speech $hasSpeech");
    speechAvailable = hasSpeech;
  }

  void errorListener(SpeechRecognitionError error) {
    lastError = error.errorMsg;

  }

  void statusListener(String status) {
    lastStatus = status;
  }

  Future<void> startListening()  async{
    lastWords = '';
    lastError = '';
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 5),
        partialResults: true, localeId: "ko_KR", onSoundLevelChange: soundLevelListener, cancelOnError: true, listenMode: ListenMode.confirmation);
  }

  Future<void> stopListening() async {
    await speech.stop();
      level = 0.0;
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    ++resultListened;



     setState(() {
       word1 = result.recognizedWords;
       word2 = result.finalResult;
       resultAvailable = true;
       stopListening();


     });


  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
  }
}
