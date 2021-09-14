import 'dart:collection';

import 'package:cs_senior_project_merchant/models/address.dart';
import 'package:flutter/material.dart';

class AddressNotifier with ChangeNotifier {
  List<Address> _addressList = [];

  UnmodifiableListView<Address> get addressList =>
      UnmodifiableListView(_addressList);

  set addressList(List<Address> addressList) {
    _addressList = addressList;
    notifyListeners();
  }

  addAddress(Address address) {
    _addressList.insert(0, address);
    notifyListeners();
  }
}
