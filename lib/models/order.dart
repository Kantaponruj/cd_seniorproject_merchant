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
  String dateOrdered;
  String timeOrdered;
  String startWaitingTime;
  String endWaitingTime;
  String netPrice;
  String amountOfMenu;
  String typeOrder;

  OrderDetail();

  OrderDetail.fromMap(Map<String, dynamic> data) {
    documentId = data['documentId'];
    orderId = data['orderId'];
    customerId = data['customerId'];
    customerName = data['customerName'];
    phone = data['phone'];
    address = data['address'];
    addressDetail = data['addressDetail'];
    geoPoint = data['geoPoint'];
    message = data['message'];
    dateOrdered = data['dateOrdered'];
    timeOrdered = data['timeOrdered'];
    startWaitingTime = data['startWaitingTime'];
    endWaitingTime = data['endWaitingTime'];
    netPrice = data['netPrice'];
    amountOfMenu = data['amountOfFood'];
    typeOrder = data['typeOrder'];
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'orderId': orderId,
      'customerId': customerId,
      'customerName': customerName,
      'phone': phone,
      'address': address,
      'addressDetail': addressDetail,
      'geoPoint': geoPoint,
      'message': message,
      'dateOrdered': dateOrdered,
      'timeOrdered': timeOrdered,
      'startWaitingTime': startWaitingTime,
      'endWaitingTime': endWaitingTime,
      'netPrice': netPrice,
      'amountOfMenu': amountOfMenu,
      'typeOrder': typeOrder
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
  String storeId;

  OrderMenu();

  OrderMenu.fromMap(Map<String, dynamic> data) {
    menuId = data['menuId'];
    menuName = data['menuName'];
    totalPrice = data['totalPrice'];
    amount = data['amount'];
    other = data['other'];
    topping = data['topping'];
    storeId = data['storeId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'menuId': menuId,
      'menuName': menuName,
      'totalPrice': totalPrice,
      'amount': amount,
      'other': other,
      'topping': topping,
      'storeId': storeId,
    };
  }
}
