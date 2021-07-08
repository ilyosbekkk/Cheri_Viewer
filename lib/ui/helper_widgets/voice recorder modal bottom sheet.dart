import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:viewerapp/business_logic/providers/search%20provider.dart';

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
  bool word2 = false;
  List<LocaleName> localeNames = [];
  final SpeechToText speech = SpeechToText();

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
    if(word1.isNotEmpty || word1 != ""){
      Navigator.pop(context, word1);
    }
    return Container(
      height: widget._height * 0.4,
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

    word1 = result.recognizedWords;

    word2 = result.finalResult;
    print(result.recognizedWords);
    print(result.finalResult);
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
  }
}
