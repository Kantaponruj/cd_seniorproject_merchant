import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/models/dateTime.dart';
import 'package:cs_senior_project_merchant/models/store.dart';
import 'package:cs_senior_project_merchant/notifiers/dateTime_notifier.dart';

class StoreService {
  String collection = "stores";

  void createUser({
    String storeId,
    String email,
  }) {
    firebaseFirestore.collection(collection).doc(storeId).set({
      'storeId': storeId,
      'email': email,
    });
  }

  void updateUserData(Map<String, dynamic> value) {
    firebaseFirestore
        .collection(collection)
        .doc(value['storeId'])
        .update(value);
  }

  Future<Store> getUserById(String storeId) => firebaseFirestore
      .collection(collection)
      .doc(storeId)
      .get()
      .then((doc) => Store.fromSnapshot(doc));
}

addDateAndTime(
  DateTime dateTime,
  String storeId,
  Function onSaveDateTime,
) async {
  CollectionReference storeRef = firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('openingHours');

  DocumentReference documentRef = await storeRef.add(dateTime.toMap());
  await documentRef.set(dateTime.toMap(), SetOptions(merge: true));

  onSaveDateTime(dateTime);
}

getDateAndTime(DateTimeNotifier dateTimeNotifier, String storeId) async {
  QuerySnapshot snapshot = await firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('openingHours')
      .get();

  List<DateTime> _dateTimeList = [];

  snapshot.docs.forEach((document) {
    DateTime dateTime = DateTime.fromMap(document.data());
    _dateTimeList.add(dateTime);
  });

  dateTimeNotifier.dateTimeList = _dateTimeList;
}
