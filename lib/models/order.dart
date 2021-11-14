import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetail {
  String documentId;
  String orderId;
  String customerId;
  String customerName;
  String phone;
  String address;
  // String addressName;
  String addressDetail;
  GeoPoint geoPoint;
  String message;
  String dateOrdered;
  String timeOrdered;
  String netPrice;
  String amountOfMenu;
  // GeoPoint testPoint;

  OrderDetail();

  OrderDetail.fromMap(Map<String, dynamic> data) {
    documentId = data['documentId'];
    orderId = data['orderId'];
    customerId = data['customerId'];
    customerName = data['customerName'];
    phone = data['phone'];
    address = data['address'];
    // addressName = data['addressName'];
    addressDetail = data['addressDetail'];
    geoPoint = data['geoPoint'];
    message = data['message'];
    dateOrdered = data['dateOrdered'];
    timeOrdered = data['timeOrdered'];
    netPrice = data['netPrice'];
    amountOfMenu = data['amountOfFood'];
    // testPoint = data['testPoint'];
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'orderId': orderId,
      'customerId': customerId,
      'customerName': customerName,
      'phone': phone,
      'address': address,
      // 'addressName': addressName,
      'addressDetail': addressDetail,
      'geoPoint': geoPoint,
      'message': message,
      'dateOrdered': dateOrdered,
      'timeOrdered': timeOrdered,
      'netPrice': netPrice,
    };
  }
}

class OrderMenu {
  String menuId;
  String menuName;
  String totalPrice;
  int amount;
  String other;
  List topping;

  OrderMenu();

  OrderMenu.fromMap(Map<String, dynamic> data) {
    menuId = data['menuId'];
    menuName = data['menuName'];
    totalPrice = data['totalPrice'];
    amount = data['amount'];
    other = data['other'];
    topping = data['topping'];
  }

  Map<String, dynamic> toMap() {
    return {
      'menuId': menuId,
      'menuName': menuName,
      'totalPrice': totalPrice,
      'amount': amount,
      'other': other,
      'topping': topping
    };
  }
}
