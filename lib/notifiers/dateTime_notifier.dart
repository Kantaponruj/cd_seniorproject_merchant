import 'dart:collection';

import 'package:cs_senior_project_merchant/models/dateTime.dart';
import 'package:flutter/material.dart';

class DateTimeNotifier with ChangeNotifier {
  List<DateTime> _dateTimeList = [];
  DateTime _dateTime;

  UnmodifiableListView<DateTime> get dateTimeList =>
      UnmodifiableListView(_dateTimeList);

  DateTime get dateTime => _dateTime;

  set dateTimeShow(DateTime dateTime) {
    _dateTime = dateTime;
    notifyListeners();
  }

  set dateTimeList(List<DateTime> dateTimeList) {
    _dateTimeList = dateTimeList;
    notifyListeners();
  }

  addDateTime(DateTime dateTime) {
    _dateTimeList.insert(0, dateTime);
    notifyListeners();
  }
}
