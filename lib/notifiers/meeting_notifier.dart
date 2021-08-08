import 'dart:collection';

import 'package:cs_senior_project/models/meeting.dart';
import 'package:flutter/foundation.dart';

class MeetingNotifier with ChangeNotifier {
  List<MeetingPoint> _meetingList = [];
  MeetingPoint _currentMeeting;

  UnmodifiableListView<MeetingPoint> get meetingList =>
      UnmodifiableListView(_meetingList);

  MeetingPoint get currentMeeting => _currentMeeting;

  set meetingList(List<MeetingPoint> meetingList) {
    _meetingList = meetingList;
    notifyListeners();
  }

  set currentMeeting(MeetingPoint meetingPoint) {
    _currentMeeting = meetingPoint;
    notifyListeners();
  }
}
