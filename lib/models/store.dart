import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  String storeId;
  String storeName;
  String description;
  String image;
  String typeOfStore;
  bool isDelivery;
  bool isPickUp;
  String email;
  String phone;
  List kindOfFood;
  bool deliveryStatus;
  bool storeStatus;
  String selectedAddressName;
  String selectedAddress;
  GeoPoint selectedLocation;
  GeoPoint realtimeLocation;

  Store();

  Store.fromSnapshot(DocumentSnapshot snapshot) {
    storeId = snapshot.data()['storeId'];
    storeName = snapshot.data()['storeName'];
    description = snapshot.data()['description'];
    image = snapshot.data()['image'];
    typeOfStore = snapshot.data()['typeOfStore'];
    isDelivery = snapshot.data()['isDelivery'];
    isPickUp = snapshot.data()['isPickUp'];
    email = snapshot.data()['email'];
    phone = snapshot.data()['phone'];
    kindOfFood = snapshot.data()['kindOfFood'];
    deliveryStatus = snapshot.data()['deliveryStatus'];
    storeStatus = snapshot.data()['storeStatus'];
    selectedAddressName = snapshot.data()['selectedAddressName'];
    selectedAddress = snapshot.data()['selectedAddress'];
    selectedLocation = snapshot.data()['selectedLocation'];
    realtimeLocation = snapshot.data()['realtimeLocation'];
  }
}
