import 'dart:collection';

import 'package:cs_senior_project_merchant/models/address.dart';
import 'package:flutter/material.dart';

class AddressNotifier with ChangeNotifier {
  List<Address> _addressList = [];
  Address _currentAddress;

  UnmodifiableListView<Address> get addressList =>
      UnmodifiableListView(_addressList);

  Address get currentAddress => _currentAddress;

  set addressList(List<Address> addressList) {
    _addressList = addressList;
    notifyListeners();
  }

  set currentAddress(Address address) {
    _currentAddress = address;
    notifyListeners();
  }

  addAddress(Address address) {
    _addressList.insert(0, address);
    notifyListeners();
  }

  deleteAddress(Address address) {
    _addressList
        .removeWhere((_address) => _address.addressId == address.addressId);
    notifyListeners();
  }
}
