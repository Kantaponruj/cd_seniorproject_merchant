import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/orderCard.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/component/textformfield.dart';
import 'package:cs_senior_project_merchant/models/address.dart';
import 'package:cs_senior_project_merchant/notifiers/address_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/location_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/store/address.dart';
import 'package:cs_senior_project_merchant/screens/store/select_address.dart';
import 'package:cs_senior_project_merchant/services/store_service.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditAddress extends StatefulWidget {
  const EditAddress({Key key}) : super(key: key);

  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  Address _currentAddress;
  TextEditingController addressName = new TextEditingController();
  TextEditingController addressDetail = new TextEditingController();

  @override
  void initState() {
    AddressNotifier address =
        Provider.of<AddressNotifier>(context, listen: false);
    _currentAddress = address.currentAddress;
    super.initState();
  }

  _saveAddress() {
    StoreNotifier store = Provider.of<StoreNotifier>(context, listen: false);
    LocationNotifier location =
        Provider.of<LocationNotifier>(context, listen: false);

    _currentAddress.geoPoint = GeoPoint(
      location.currentPosition.latitude,
      location.currentPosition.longitude,
    );

    saveAddress(_currentAddress, store.store.storeId, true);
    Navigator.pop(context);
  }

  int count;

  _deleteFood(Address address) {
    StoreNotifier store = Provider.of<StoreNotifier>(context, listen: false);
    AddressNotifier addressNotifier =
        Provider.of<AddressNotifier>(context, listen: false);
    addressNotifier.deleteAddress(address);
    count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    StoreNotifier store = Provider.of<StoreNotifier>(context, listen: false);

    return Scaffold(
      appBar: RoundedAppBar(
        appBarTittle: 'แก้ไขข้อมูลที่อยู่',
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              BuildCard(
                headerText: 'ที่อยู่',
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          alignment: Alignment.topRight,
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SelectAddress(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                primary: Theme.of(context).buttonColor),
                            child: Text(
                              'เลือกบนแผนที่',
                              style: FontCollection.smallBodyTextStyle,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: CollectionsColors.grey),
                        child: Text(_currentAddress.address),
                      ),
                      Container(
                        child: buildTextFormField(
                          'ชื่อสถานที่',
                          TextInputType.text,
                          (value) {
                            if (value.isEmpty) {
                              return 'โปรดกรอก';
                            }
                            return null;
                          },
                          _currentAddress.addressName,
                          onChanged: (value) {
                            _currentAddress.addressName = value;
                          },
                        ),
                      ),
                      Container(
                        child: buildTextFormField(
                            'รายละเอียดสถานที่',
                            TextInputType.text,
                            (value) {
                              if (value.isEmpty) {
                                return 'โปรดกรอก';
                              }
                              return null;
                            },
                            _currentAddress.addressDetail,
                            onChanged: (value) {
                              _currentAddress.addressDetail = value;
                            }),
                      ),
                    ],
                  ),
                ),
                canEdit: false,
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: StadiumButtonWidget(
                  text: 'บันทึก',
                  onClicked: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _saveAddress();
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: EditButton(
                  onClicked: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: AlertDialog(
                            title: Text(
                              'ยืนยันที่จะลบข้อมูลที่อยู่นี้หรือไม่',
                              style: FontCollection.bodyTextStyle,
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Text(
                                        'ยกเลิก',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: CollectionsColors.red),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: ButtonWidget(
                                      text: 'ยืนยัน',
                                      onClicked: () {
                                        deleteAddress(
                                          _currentAddress,
                                          store.store.storeId,
                                          _deleteFood,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                  editText: 'ลบที่อยู่',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(String labelText, TextInputType keyboardType,
      String Function(String) validator, String initialValue,
      {Function(String) onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: BuildTextField(
        labelText: labelText,
        onChanged: onChanged,
        textInputType: keyboardType,
        validator: validator,
        initialValue: initialValue,
      ),
    );
  }
}
