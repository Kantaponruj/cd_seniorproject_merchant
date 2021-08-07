import 'dart:collection';

import 'package:cs_senior_project_merchant/models/menu.dart';
import 'package:flutter/material.dart';

class MenuNotifier with ChangeNotifier {
  List<Menu> _menuList = [];

  UnmodifiableListView<Menu> get menuList => UnmodifiableListView(_menuList);

  set menuList(List<Menu> menuList) {
    _menuList = menuList;
    notifyListeners();
  }
}
