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

Stream<QuerySnapshot> getOrders(String storeId, String typeOrder) {
  return firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection(typeOrder)
      .orderBy('timeOrdered')
      .snapshots();
}

Future<void> getOrderMenu(
  OrderNotifier orderNotifier,
  String storeId,
  String documentId,
  String typeOrder,
) async {
  QuerySnapshot snapshot = await firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection(typeOrder)
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

updateStatusOrder(
  String uid,
  String storeId,
  String orderId,
  String docId,
  String orderStatus,
) {
  firebaseFirestore
      .collection('users')
      .doc(uid)
      .collection('activities')
      .doc(orderId)
      .update({'orderStatus': orderStatus});

  firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('delivery-orders')
      .doc(docId)
      .update({'orderStatus': orderStatus});

  print('Updated Status');
}

completedOrder(String storeId, String documentId) {
  firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('delivery-orders')
      .doc(documentId)
      .delete();
}

String documentId;

saveOrderToHistory(String storeId, OrderDetail orderDetail) {
  DocumentReference documentRef = firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('history')
      .doc();

  documentId = documentRef.id;
  orderDetail.documentId = documentId;

  documentRef.set(orderDetail.toMap(), SetOptions(merge: true));
}

saveOrderMenuToHistory(String storeId, OrderMenu orderMenu) async {
  CollectionReference historyRef = firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('history')
      .doc(documentId)
      .collection('orders');

  DocumentReference documentRef = await historyRef.add(orderMenu.toMap());
  await documentRef.set(orderMenu.toMap(), SetOptions(merge: true));
}
