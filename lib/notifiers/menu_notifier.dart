import 'dart:collection';

import 'package:cs_senior_project_merchant/models/menu.dart';
import 'package:flutter/material.dart';

class MenuNotfier with ChangeNotifier {
  List<Menu> _menuList = [];
  Menu _currentMenu;

  UnmodifiableListView<Menu> get menuList => UnmodifiableListView(_menuList);

  Menu get currentMenu => _currentMenu;

  set menuList(List<Menu> menu) {
    _menuList = menu;
    notifyListeners();
  }

  set currentMenu(Menu menu) {
    _currentMenu = menu;
    notifyListeners();
  }

  addMenu(Menu menu) {
    _menuList.add(menu);
    notifyListeners();
  }

  deleteMenu(Menu menu) {
    _menuList.removeWhere((_menu) => _menu.menuId == menu.menuId);
    notifyListeners();
  }
}
