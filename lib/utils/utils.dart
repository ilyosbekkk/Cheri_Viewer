import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:viewerapp/utils/strings.dart';
import 'package:flutter/material.dart';
import 'dart:async';


//vars
SharedPreferences? userPreferences;
SharedPreferences? languagePreferences;

const int pageSize = 10;
const int category = 0;
const orderBy = "views";



//util functions
void showToast(String message) {
  Fluttertoast.showToast(msg: message,
      toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1, backgroundColor: Colors.black54, textColor: Colors.white, fontSize: 16.0);
}

String timeFormatter(String formattedString, String language) {

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
            return timeUnit[language]![0];
          else
            return "$minsDiff ${timeUnit[language]![1]}";
        } else {
          return "$hoursDiff ${timeUnit[language]![2]}";
        }
      } else {
        if (dayDiff <= 6)
          return "$dayDiff ${timeUnit[language]![3]}";
        else
          return "${dayDiff ~/ 7} ${timeUnit[language]![4]}";
      }
    } else {
      return "$monthDiff ${timeUnit[language]![5]}";
    }
  } else {
    return "$yearDiff ${timeUnit[language]![6]}";
  }
}

Future<void> initPreferences() async {
  userPreferences = await SharedPreferences.getInstance();
  languagePreferences = await SharedPreferences.getInstance();
}


//enums
enum CheriState{
  SAVED,
  UNSAVED,
  IDLE
}
enum Button { BOOKMARK, OPEN_CHERI }


