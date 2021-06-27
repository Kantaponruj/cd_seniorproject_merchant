import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/models/menu.dart';
import 'package:cs_senior_project/notifiers/menu_notifier.dart';

getMenu(MenuNotifier menuNotifier, String meetingId) async {
  QuerySnapshot snapshot = await firebaseFirestore
      .collection('meeting-point')
      .doc(meetingId)
      .collection('orders')
      .get();

  List<Menu> _menuList = [];

  snapshot.docs.forEach((document) {
    Menu menu = Menu.fromMap(document.data());
    _menuList.add(menu);
  });

  menuNotifier.menuList = _menuList;
}
