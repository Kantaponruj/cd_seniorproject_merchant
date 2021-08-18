import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/models/store.dart';

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
