import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  String storeId;
  String name;
  String address;
  String image;
  GeoPoint location;
  bool isDelivery;
  bool isPickUp;
  String email;

  Store();

  // Store.fromMap(Map<String, dynamic> data) {
  //   storeId = data['storeId'];
  //   name = data['name'];
  //   address = data['address'];
  //   image = data['image'];
  //   location = data['location'];
  //   isDelivery = data['isDelivery'];
  //   isPickUp = data['isPickUp'];
  //   email = data['email'];
  // }

  Store.fromSnapshot(DocumentSnapshot snapshot) {
    storeId = snapshot.data()['storeId'];
    name = snapshot.data()['name'];
    address = snapshot.data()['address'];
    image = snapshot.data()['image'];
    location = snapshot.data()['location'];
    isDelivery = snapshot.data()['isDelivery'];
    isPickUp = snapshot.data()['isPickUp'];
    email = snapshot.data()['email'];
  }
}
