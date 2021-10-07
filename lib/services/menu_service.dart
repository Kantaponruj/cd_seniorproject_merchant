import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/models/menu.dart';
import 'package:cs_senior_project_merchant/notifiers/menu_notifier.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

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

updateMenuAndImage(
  Menu menu,
  bool isUpdating,
  File localFile,
  Function menuUploaded,
  String storeId,
) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uudid = Uuid().v4();

    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('menu/$uudid$fileExtension');

    await firebaseStorageRef.putFile(localFile).catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();

    print("download url: $url");
    _uploadMenu(menu, isUpdating, menuUploaded, storeId, imageUrl: url);
  } else {
    print("...skipping image upload");
    _uploadMenu(menu, isUpdating, menuUploaded, storeId);
  }
}

_uploadMenu(Menu menu, bool isUpdating, Function menuUploaded, String storeId,
    {String imageUrl}) async {
  CollectionReference menuRef =
      firebaseFirestore.collection('stores').doc(storeId).collection('menu');

  if (imageUrl != null) {
    menu.image = imageUrl;
  }

  if (isUpdating) {
    await menuRef.doc(menu.menuId).update(menu.toMap());

    menuUploaded(menu);
    print("updated menu with id: ${menu.menuId}");
  } else {
    DocumentReference documentRef = await menuRef.add(menu.toMap());

    menu.menuId = documentRef.id;

    print("uploaded food successfully: ${menu.toString}");

    await documentRef.set(menu.toMap(), SetOptions(merge: true));

    menuUploaded(menu);
  }
}

deleteMenu(Menu menu, Function menuDeleted, String storeId) async {
  if (menu.image != null) {
    Reference storageRef =
        await FirebaseStorage.instance.refFromURL(menu.image);

    await storageRef.delete();

    print('image deleted');
  }

  await FirebaseFirestore.instance
      .collection('stores')
      .doc(storeId)
      .collection('menu')
      .doc(menu.menuId)
      .delete();

  menuDeleted(menu);
}
