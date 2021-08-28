import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/models/meeting.dart';
import 'package:cs_senior_project_merchant/notifiers/meeting_notifier.dart';

Future<void> getMeeting(MeetingNotifier meetingNotifier) async {
  QuerySnapshot snapshot =
      await firebaseFirestore.collection('meeting-point').get();

  List<MeetingPoint> _meetingList = [];

  snapshot.docs.forEach((document) {
    MeetingPoint meetingPoint = MeetingPoint.fromMap(document.data());
    _meetingList.add(meetingPoint);
  });

  meetingNotifier.meetingList = _meetingList;
}
