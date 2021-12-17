import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  String storeId;
  String storeName;
  String description;
  String image;
  String typeOfStore;
  bool isDelivery;
  String email;
  String phone;
  List kindOfFood;
  bool storeStatus;
  String selectedAddressName;
  String selectedAddress;
  GeoPoint selectedLocation;
  GeoPoint realtimeLocation;
  String distanceForOrder;
  String shippingfee;

  Store();

  Store.fromSnapshot(DocumentSnapshot snapshot) {
    storeId = snapshot.data()['storeId'];
    storeName = snapshot.data()['storeName'];
    description = snapshot.data()['description'];
    image = snapshot.data()['image'];
    typeOfStore = snapshot.data()['typeOfStore'];
    isDelivery = snapshot.data()['isDelivery'];
    email = snapshot.data()['email'];
    phone = snapshot.data()['phone'];
    kindOfFood = snapshot.data()['kindOfFood'];
    storeStatus = snapshot.data()['storeStatus'];
    selectedAddressName = snapshot.data()['selectedAddressName'];
    selectedAddress = snapshot.data()['selectedAddress'];
    selectedLocation = snapshot.data()['selectedLocation'];
    realtimeLocation = snapshot.data()['realtimeLocation'];
    distanceForOrder = snapshot.data()['distanceForOrdre'];
    shippingfee = snapshot.data()['shippingfee'];
  }
}
