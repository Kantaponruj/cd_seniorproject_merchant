import 'dart:collection';

import 'package:cs_senior_project_merchant/models/dateTime.dart';
import 'package:flutter/material.dart';

class DateTimeNotifier with ChangeNotifier {
  List<DateTimeModel> _dateTimeList = [];
  DateTimeModel _currentDateTime;

  UnmodifiableListView<DateTimeModel> get dateTimeList =>
      UnmodifiableListView(_dateTimeList);

  DateTimeModel get currentDateTime => _currentDateTime;

  set dateTimeList(List<DateTimeModel> dateTimeList) {
    _dateTimeList = dateTimeList;
    notifyListeners();
  }

  set currentDateTime(DateTimeModel dateTime) {
    _currentDateTime = dateTime;
    notifyListeners();
  }

  addDateTime(DateTimeModel dateTime, int index) {
    _dateTimeList.insert(index, dateTime);
    notifyListeners();
  }

  deleteDateAndTime(DateTimeModel dateTime) {
    _dateTimeList.removeWhere((doc) => doc.docId == dateTime.docId);
    notifyListeners();
  }
}
