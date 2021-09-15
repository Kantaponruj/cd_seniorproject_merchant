import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/models/order.dart';
import 'package:cs_senior_project_merchant/notifiers/order_notifier.dart';

// Future<void> getOrderDelivery(
//   OrderNotifier orderNotifier,
//   String storeId,
// ) async {
//   QuerySnapshot snapshot = await firebaseFirestore
//       .collection('stores')
//       .doc(storeId)
//       .collection('delivery-orders')
//       .orderBy('timeOrdered')
//       .get();

//   List<OrderDetail> _orderList = [];

//   snapshot.docs.forEach((document) {
//     OrderDetail order = OrderDetail.fromMap(document.data());
//     _orderList.add(order);
//   });

//   orderNotifier.orderList = _orderList;
// }

Future<void> getOrderMenu(
  OrderNotifier orderNotifier,
  String storeId,
  String documentId,
) async {
  QuerySnapshot snapshot = await firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('delivery-orders')
      .doc(documentId)
      .collection('orders')
      .get();

  List<OrderMenu> _orderMenuList = [];

  snapshot.docs.forEach((document) {
    OrderMenu menu = OrderMenu.fromMap(document.data());
    _orderMenuList.add(menu);
  });

  orderNotifier.orderMenuList = _orderMenuList;
}

updateStatusOrder(String uid, String orderId, String orderStatus) {
  firebaseFirestore
      .collection('users')
      .doc(uid)
      .collection('activities')
      .doc(orderId)
      .update({'orderStatus': orderStatus});

  print('Updated Status');
}

Future<void> completedOrder(String storeId, String documentId) {
  return firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('delivery-orders')
      .doc(documentId)
      .delete()
      .then((value) => print("Completed order!"));
}
