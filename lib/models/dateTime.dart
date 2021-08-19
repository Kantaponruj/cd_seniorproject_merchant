class DateTime {
  String openTime;
  String closeTime;
  List<String> dates = [];

  DateTime();

  DateTime.fromMap(Map<String, dynamic> data) {
    openTime = data['openTime'];
    closeTime = data['closeTime'];
    dates = data['dates'];
  }

  Map<String, dynamic> toMap() {
    return {'openTime': openTime, 'closeTime': closeTime, 'date': dates};
  }
}
