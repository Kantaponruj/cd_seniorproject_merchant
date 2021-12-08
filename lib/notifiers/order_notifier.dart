import 'dart:collection';

import 'package:cs_senior_project_merchant/models/order.dart';
import 'package:flutter/foundation.dart';

class OrderNotifier with ChangeNotifier {
  List _orderList = [];
  List<OrderMenu> _orderMenuList = [];

  OrderDetail _currentOrder;

  UnmodifiableListView get orderList => UnmodifiableListView(_orderList);
  UnmodifiableListView<OrderMenu> get orderMenuList =>
      UnmodifiableListView(_orderMenuList);

  OrderDetail get currentOrder => _currentOrder;

  set orderList(List orderList) {
    Future.delayed(Duration(seconds: 1), () {
      _orderList = orderList;
      notifyListeners();
    });
  }

  set currentOrder(OrderDetail order) {
    _currentOrder = order;
    notifyListeners();
  }

  set orderMenuList(List<OrderMenu> orderMenuList) {
    _orderMenuList = orderMenuList;
    notifyListeners();
  }
}
