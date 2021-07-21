import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? preferences;

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
  preferences = await SharedPreferences.getInstance();
}

enum CheriState{
  SAVED,
  UNSAVED,
  IDLE
}
