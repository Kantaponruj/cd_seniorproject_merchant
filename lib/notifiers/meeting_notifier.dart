import 'dart:collection';

import 'package:cs_senior_project/models/meeting.dart';
import 'package:flutter/foundation.dart';

class MeetingNotifier with ChangeNotifier {
  List<MeetingPoint> _meetingList = [];

  UnmodifiableListView<MeetingPoint> get meetingList =>
      UnmodifiableListView(_meetingList);

  set meetingList(List<MeetingPoint> meetingList) {
    _meetingList = meetingList;
    notifyListeners();
  }
}
