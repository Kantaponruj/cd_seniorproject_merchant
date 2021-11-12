import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/models/address.dart';
import 'package:cs_senior_project_merchant/models/dateTime.dart';
import 'package:cs_senior_project_merchant/models/store.dart';
import 'package:cs_senior_project_merchant/notifiers/address_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/dateTime_notifier.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class StoreService {
  String collection = "stores";

  void createUser({
    String storeId,
    String email,
  }) {
    firebaseFirestore.collection(collection).doc(storeId).set({
      'storeId': storeId,
      'email': email,
      'deliveryStatus': false,
      'storeStatus': false
    });
  }

  void updateUserData(String storeId, Map<String, dynamic> value) {
    firebaseFirestore.collection(collection).doc(storeId).update(value);
  }

  Future<Store> getUserById(String storeId) => firebaseFirestore
      .collection(collection)
      .doc(storeId)
      .get()
      .then((doc) => Store.fromSnapshot(doc));
}

updateImageStore(String storeId, File localFile) async {
  CollectionReference storeRef = firebaseFirestore.collection('stores');

  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uudid = Uuid().v4();

    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('store_img/$uudid$fileExtension');

    await firebaseStorageRef.putFile(localFile).catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    await storeRef.doc(storeId).update({'image': url});
    print("download url: $url");
  }
  // else {
  //   await storeRef.doc(store.storeId).update(value);
  //   print("...skipping image upload");
  // }
}

// _updateStoreProfile(Store store, Map<String, dynamic> value,
//     {String imageUrl}) async {
//   CollectionReference storeRef = firebaseFirestore.collection('stores');

//   if (imageUrl != null) {
//     store.image = imageUrl;
//   }

//   await storeRef.doc(store.storeId).update(value);
// }

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

Future<void> getDateAndTime(
    DateTimeNotifier dateTimeNotifier, String storeId) async {
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

Future<void> getAddress(AddressNotifier addressNotifier, String storeId) async {
  QuerySnapshot snapshot = await firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('address')
      .get();

  List<Address> _addressList = [];

  snapshot.docs.forEach((document) {
    Address address = Address.fromMap(document.data());
    _addressList.add(address);
  });

  addressNotifier.addressList = _addressList;
}

saveAddress(Address address, String storeId, Function addAddress) async {
  CollectionReference addressRef =
      firebaseFirestore.collection('stores').doc(storeId).collection('address');

  DocumentReference documentRef = await addressRef.add(address.toMap());
  await documentRef.set(address.toMap(), SetOptions(merge: true));

  addAddress(address);
}

// Future<void> updateLocation(StoreNotifier store) async {
//   Position _currentPosition = await Geolocator.getCurrentPosition(
//     desiredAccuracy: LocationAccuracy.high,
//   );

//   firebaseFirestore.collection('stores').doc(store.store.storeId).update({
//     "realtimeLocation": GeoPoint(
//       _currentPosition.latitude,
//       _currentPosition.longitude,
//     )
//   });
//   print(
//     '${_currentPosition.latitude} ${_currentPosition.longitude}',
//   );

//   if (store.store.storeStatus == true) {
//     Future.delayed(Duration(seconds: 3), () {
//       updateLocation(store);
//     });
//   }
// }
