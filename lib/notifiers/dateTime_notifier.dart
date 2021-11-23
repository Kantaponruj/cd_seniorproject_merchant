import 'dart:collection';

import 'package:cs_senior_project_merchant/models/dateTime.dart';
import 'package:flutter/material.dart';

class DateTimeNotifier with ChangeNotifier {
  List<DateTimeModel> _dateTimeList = [];
  // DateTime _dateTime;

  UnmodifiableListView<DateTimeModel> get dateTimeList =>
      UnmodifiableListView(_dateTimeList);

  // DateTime get dateTime => _dateTime;

  set dateTimeList(List<DateTimeModel> dateTimeList) {
    _dateTimeList = dateTimeList;
    notifyListeners();
  }

  addDateTime(DateTimeModel dateTime, int index) {
    _dateTimeList.insert(index, dateTime);
    notifyListeners();
  }
}
