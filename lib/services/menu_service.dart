import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/models/menu.dart';
import 'package:cs_senior_project_merchant/notifiers/menu_notifier.dart';

Future<void> getMenu(MenuNotifier menuNotifier, String meetingId) async {
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
