class MeetingPoint {
  String meetingId;
  String customerName;
  String address;
  String date;
  String time;

  MeetingPoint();

  MeetingPoint.fromMap(Map<String, dynamic> data) {
    meetingId = data['meetingId'];
    customerName = data['customerName'];
    address = data['address'];
    date = data['date'];
    time = data['time'];
  }
}
