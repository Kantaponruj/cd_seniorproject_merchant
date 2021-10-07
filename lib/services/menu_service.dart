import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/models/menu.dart';
import 'package:cs_senior_project_merchant/notifiers/menu_notifier.dart';

Future<void> getMenu(MenuNotfier menuNotfier, String storeId) async {
  QuerySnapshot snapshot = await firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('menu')
      .get();

  List<Menu> _menuList = [];

  snapshot.docs.forEach((document) {
    Menu menu = Menu.fromMap(document.data());
    _menuList.add(menu);
  });

  menuNotfier.menuList = _menuList;
}
