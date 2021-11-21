import 'dart:collection';

import 'package:cs_senior_project_merchant/models/menu.dart';
import 'package:flutter/material.dart';

class MenuNotfier with ChangeNotifier {
  List<String> _categoriesList = [];
  List<Menu> _menuList = [];
  // List<Topping> _toppingList = [];
  Menu _currentMenu;
  // Topping _currentTopping;

  UnmodifiableListView<Menu> get menuList => UnmodifiableListView(_menuList);
  // UnmodifiableListView<Topping> get toppingList =>
  //     UnmodifiableListView(_toppingList);

  List<String> get categoriesList => _categoriesList;
  Menu get currentMenu => _currentMenu;
  // Topping get currentTopping => _currentTopping;

  set categoriesList(List<String> categories) {
    _categoriesList = categories;
    notifyListeners();
  }

  set menuList(List<Menu> menu) {
    _menuList = menu;
    notifyListeners();
  }

  set currentMenu(Menu menu) {
    _currentMenu = menu;
    notifyListeners();
  }

  // set toppingList(List<Topping> topping) {
  //   _toppingList = topping;
  //   notifyListeners();
  // }

  addMenu(Menu menu) {
    _menuList.add(menu);
    notifyListeners();
  }

  deleteMenu(Menu menu) {
    _menuList.removeWhere((_menu) => _menu.menuId == menu.menuId);
    notifyListeners();
  }
}
