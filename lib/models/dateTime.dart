class DateTimeModel {
  String docId;
  String openTime;
  String closeTime;
  List dates = [];

  DateTimeModel();

  DateTimeModel.fromMap(Map<String, dynamic> data) {
    docId = data['docId'];
    openTime = data['openTime'];
    closeTime = data['closeTime'];
    dates = data['date'];
  }

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'openTime': openTime,
      'closeTime': closeTime,
      'date': dates
    };
  }
}
