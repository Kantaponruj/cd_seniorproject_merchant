class MeetingPoint {
  String meetingId;
  String customerName;
  String dateTime;

  MeetingPoint();

  MeetingPoint.fromMap(Map<String, dynamic> data) {
    meetingId = data['meetingId'];
    customerName = data['customerName'];
    dateTime = data['dateTime'];
  }
}
