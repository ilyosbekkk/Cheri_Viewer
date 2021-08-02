import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';



SharedPreferences? userPreferences;
SharedPreferences? languagePreferences;

const int pageSize = 10;
const int category = 0;
const orderBy = "views";


void showToast(String message) {
  Fluttertoast.showToast(msg: message,
      toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1, backgroundColor: Colors.black54, textColor: Colors.white, fontSize: 16.0);
}

String timeFormatter(String formattedString) {

  var nowTime = DateTime.now();
  var postCreationTime = DateTime.parse(formattedString);
  int yearDiff = nowTime.year - postCreationTime.year;
  if (yearDiff == 0) {
    int monthDiff = nowTime.month - postCreationTime.month;
    if (monthDiff == 0) {
      int dayDiff = nowTime.day - postCreationTime.day;
      if (dayDiff == 0) {
        int hoursDiff = nowTime.hour - postCreationTime.hour;
        if (hoursDiff == 0) {
          int minsDiff = nowTime.minute - postCreationTime.minute;
          if (minsDiff == 0)
            return "방금";
          else
            return "$minsDiff 분";
        } else {
          return "$hoursDiff 시간";
        }
      } else {
        if (dayDiff <= 6)
          return "$dayDiff 일";
        else
          return "${dayDiff ~/ 7} 주";
      }
    } else {
      return "$monthDiff 개 월";
    }
  } else {
    return "$yearDiff 년";
  }
}

Future<void> initPreferences() async {
  userPreferences = await SharedPreferences.getInstance();
  languagePreferences = await SharedPreferences.getInstance();
}

enum CheriState{
  SAVED,
  UNSAVED,
  IDLE
}


class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}