import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:viewerapp/business_logic/services/web services.dart';
import 'package:viewerapp/models/postslist_model.dart';
import 'package:viewerapp/models/search%20model.dart';

class SearchProvider extends ChangeNotifier {
  List<Post> _searchResults = [];
  List<SearchWord> _recentSearches = [];
  List<SearchWord> _relatedSearches = [];

  Future<bool> searchPostByTitle(int pageSize, int nowPage, String orderBy, String searchWord, String memberId) async {
    if (_searchResults.isNotEmpty) _searchResults.clear();
    try {
      Response response = await WebServices.searchPostByTitle(pageSize, nowPage, orderBy, searchWord, memberId);
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        PostsResponse postsResponse = PostsResponse.fromJson(decodedResponse);
        print("result");
        print(decodedResponse);
        _searchResults.addAll(postsResponse.data);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> fetchRecentSearches(String memberId) async {
    bool result = false;
    if (_recentSearches.isNotEmpty) _recentSearches.clear();
    try {
      Response response = await WebServices.fetchRecentSearches(memberId);
      Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        Search search = Search.fromJson(decodedResponse);
        _recentSearches.addAll(search.searchWords!);
        print(decodedResponse);
        result = true;
        notifyListeners();
      }
      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> fetchRelatedSearches(String memberId, String searchWord) async {
    bool result = false;
    if (_relatedSearches.isNotEmpty) _relatedSearches.clear();
    try {
      Response response = await WebServices.fetchRelatedSearches(memberId, searchWord);
      Map<String, dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        Search search = Search.fromJson(decodedResponse);
        print("related searches:");
        print(decodedResponse);
        _relatedSearches.addAll(search.searchWords!);
        result = true;
        notifyListeners();
      }
      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  List<Post> get searchResults => _searchResults;

  List<SearchWord> get relatedSearches => _relatedSearches;

  List<SearchWord> get recentSearches => _recentSearches;

  void cleanList() {
    if (_searchResults.isNotEmpty) _searchResults.clear();
  }

  //region Speech recognition
  bool has_speech = false;
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

  Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(
      onError: errorListener,
      onStatus: statusListener,
      debugLogging: true,
      finalTimeout: Duration(milliseconds: 0),
    );
    if (hasSpeech) {
      localeNames = await speech.locales();
      var systemLocale = await speech.systemLocale();
      currentLocaleId = systemLocale?.localeId ?? '';
    }
    has_speech = hasSpeech;
    notifyListeners();
  }

  void errorListener(SpeechRecognitionError error) {
    lastError = error.errorMsg;
    notifyListeners();
  }

  void statusListener(String status) {
    lastStatus = status;
    notifyListeners();
  }

  void startListening() {
    lastWords = '';
    lastError = '';
    speech.listen(
      onResult: resultListener,
      listenFor: Duration(seconds: 30),
      pauseFor: Duration(seconds: 5),
      partialResults: true,
      localeId: currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      listenMode: ListenMode.confirmation
    );
    notifyListeners();
  }

  void stopListening() {
    speech.stop();
    level = 0.0;
    notifyListeners();
  }

  void cancelListening() {
    speech.cancel();
    level = 0.0;
    notifyListeners();
  }

  void resultListener(SpeechRecognitionResult result) {
    ++resultListened;
    print("Result listened $resultListened");
    print("Results");
    word1 = result.recognizedWords;
    word2  = result.finalResult;
    print(result.recognizedWords);
    print(result.finalResult);
    notifyListeners();
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    notifyListeners();
  }

  void switchLang(selectedVal) {
    currentLocaleId = selectedVal;
    notifyListeners();
  }
  //endregion
}
