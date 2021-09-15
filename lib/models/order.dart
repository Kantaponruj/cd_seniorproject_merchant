import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetail {
  String documentId;
  String orderId;
  String customerId;
  String customerName;
  String phone;
  String address;
  String addressDetail;
  GeoPoint geoPoint;
  String message;
  String netPrice;
  String dateOrdered;
  String timeOrdered;

  OrderDetail();

  OrderDetail.fromMap(Map<String, dynamic> data) {
    documentId = data['documentId'];
    orderId = data['orderId'];
    customerId = data['customerId'];
    customerName = data['customerName'];
    address = data['address'];
    addressDetail = data['addressDetail'];
    geoPoint = data['geoPoint'];
    message = data['message'];
    netPrice = data['netPrice'];
    dateOrdered = data['dateOrdered'];
    timeOrdered = data['timeOrdered'];
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
}
