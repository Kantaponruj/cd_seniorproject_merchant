import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  String storeId;
  String name;
  String address;
  String image;
  GeoPoint location;

  Store();

  Store.fromMap(Map<String, dynamic> data) {
    storeId = data['storeId'];
    name = data['name'];
    address = data['address'];
    image = data['image'];
    location = data['location'];
  }
}
