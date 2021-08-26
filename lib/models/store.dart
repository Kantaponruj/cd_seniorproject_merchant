import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  String storeId;
  String storeName;
  String description;
  String image;
  bool isDelivery;
  bool isPickUp;
  String email;
  String phone;
  String kindOfFood;
  bool deliveryStatus;
  bool storeStatus;

  Store();

  Store.fromSnapshot(DocumentSnapshot snapshot) {
    storeId = snapshot.data()['storeId'];
    storeName = snapshot.data()['storeName'];
    description = snapshot.data()['description'];
    image = snapshot.data()['image'];
    isDelivery = snapshot.data()['isDelivery'];
    isPickUp = snapshot.data()['isPickUp'];
    email = snapshot.data()['email'];
    phone = snapshot.data()['phone'];
    kindOfFood = snapshot.data()['kindOfFood'];
    deliveryStatus = snapshot.data()['deliveryStatus'];
    storeStatus = snapshot.data()['storeStatus'];
  }
}
