import 'dart:collection';

import 'package:cs_senior_project/models/store.dart';
import 'package:flutter/material.dart';

class StoreNotifier with ChangeNotifier {
  List<Store> _storeList = [];

  UnmodifiableListView<Store> get storeList => UnmodifiableListView(_storeList);

  set storeList(List<Store> storeList) {
    _storeList = storeList;
    notifyListeners();
  }
}