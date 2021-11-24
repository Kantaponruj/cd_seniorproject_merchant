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

// Future<void> getTopping(MenuNotfier menuNotfier, String storeId) async {
//   QuerySnapshot snapshot = await firebaseFirestore
//       .collection('stores')
//       .doc(storeId)
//       .collection('menu')
//       .doc(menuNotfier.currentMenu.menuId)
//       .collection('topping')
//       .get();

//   List<Topping> _toppingList = [];

//   snapshot.docs.forEach((document) {
//     Topping topping = Topping.fromMap(document.data());
//     _toppingList.add(topping);
//   });

//   menuNotfier.toppingList = _toppingList;
//   print(_toppingList);
// }

updateMenuAndImage(
  Menu menu,
  List<Topping> topping,
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
    _uploadMenu(menu, topping, isUpdating, menuUploaded, storeId,
        imageUrl: url);
  } else {
    print("...skipping image upload");
    _uploadMenu(menu, topping, isUpdating, menuUploaded, storeId);
  }
}

_uploadMenu(Menu menu, List<Topping> topping, bool isUpdating,
    Function menuUploaded, String storeId,
    {String imageUrl}) async {
  CollectionReference menuRef =
      firebaseFirestore.collection('stores').doc(storeId).collection('menu');

  if (imageUrl != null) {
    menu.image = imageUrl;
  }

  if (isUpdating) {
    await menuRef.doc(menu.menuId).update(menu.toMap());
    _uploadTopping(topping, storeId, menu.menuId, isUpdating);
    menuUploaded(menu);

    print("updated menu with id: ${menu.menuId}");
  } else {
    DocumentReference documentRef = await menuRef.add(menu.toMap());

    menu.menuId = documentRef.id;
    _uploadTopping(topping, storeId, menu.menuId, isUpdating);

    print("uploaded food successfully: ${menu.toString}");

    await documentRef.set(menu.toMap(), SetOptions(merge: true));
    menuUploaded(menu);
  }
}

_uploadTopping(List<Topping> toppingList, String storeId, String menuId,
    bool isUpdating) async {
  CollectionReference toppingRef = firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('menu')
      .doc(menuId)
      .collection('topping');

  if (isUpdating) {
    for (int i = 0; i < toppingList.length; i++) {
      if (toppingList[i].toppingId != null) {
        await toppingRef
            .doc(toppingList[i].toppingId)
            .update(toppingList[i].toMap());
      } else {
        DocumentReference documentRef =
            await toppingRef.add(toppingList[i].toMap());
        toppingList[i].toppingId = documentRef.id;
        await documentRef.set(toppingList[i].toMap(), SetOptions(merge: true));
      }
    }
  } else {
    for (int i = 0; i < toppingList.length; i++) {
      DocumentReference documentRef =
          await toppingRef.add(toppingList[i].toMap());
      toppingList[i].toppingId = documentRef.id;
      await documentRef.set(toppingList[i].toMap(), SetOptions(merge: true));
    }
  }
}

// _uploadSubTopping(List<SubTopping> subtoppingList, String storeId,
//     String menuId, String toppingId, bool isUpdating) async {
//   CollectionReference subtoppingRef = firebaseFirestore
//       .collection('stores')
//       .doc(storeId)
//       .collection('menu')
//       .doc(menuId)
//       .collection('topping')
//       .doc(toppingId)
//       .collection('subtopping');

//   if (isUpdating) {
//     for (int i = 0; i < subtoppingList.length; i++) {
//       subtoppingRef
//           .doc(subtoppingList[i].subToppingId)
//           .update(subtoppingList[i].toMap());
//     }
//   } else {
//     for (int i = 0; i < subtoppingList.length; i++) {
//       DocumentReference documentRef =
//           await subtoppingRef.add(subtoppingList[i].toMap());
//       subtoppingList[i].subToppingId = documentRef.id;
//       await documentRef.set(subtoppingList[i].toMap(), SetOptions(merge: true));
//     }
//   }
// }

deleteMenu(Menu menu, Function menuDeleted, String storeId) async {
  if (menu.image != null) {
    Reference storageRef =
        await FirebaseStorage.instance.refFromURL(menu.image);

    await storageRef.delete();

    print('image deleted');
  }

  await firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('menu')
      .doc(menu.menuId)
      .delete();

  menuDeleted(menu);
}

deleteTopping(String storeId, String menuId, String toppingId) async {
  await firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('menu')
      .doc(menuId)
      .collection('topping')
      .doc(toppingId)
      .delete();
}

updateMenuStatus(String storeId, String menuId, bool status) {
  firebaseFirestore
      .collection('stores')
      .doc(storeId)
      .collection('menu')
      .doc(menuId)
      .update({'haveMenu': status});
}
