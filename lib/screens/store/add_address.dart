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
import 'package:cs_senior_project_merchant/screens/store/select_address.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:cs_senior_project_merchant/services/store_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key key}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  Address _currentAddress;

  TextEditingController addressName = new TextEditingController();
  TextEditingController addressDetail = new TextEditingController();

  @override
  void initState() {
    _currentAddress = Address();
    super.initState();
  }

  _onAddAddress(Address address) {
    AddressNotifier addressNotifier =
        Provider.of<AddressNotifier>(context, listen: false);
    addressNotifier.addAddress(address);
    Navigator.pop(context);
  }

  _saveAddress(LocationNotifier locationNotifier) {
    StoreNotifier store = Provider.of<StoreNotifier>(context, listen: false);

    _currentAddress.address = locationNotifier.currentAddress;
    _currentAddress.geoPoint = GeoPoint(
        locationNotifier.currentPosition.latitude,
        locationNotifier.currentPosition.longitude);
    _currentAddress.addressName = addressName.text.trim();
    _currentAddress.addressDetail = addressDetail.text.trim();

    saveAddress(_currentAddress, store.store.storeId, false,
        addAddress: _onAddAddress);
  }

  @override
  Widget build(BuildContext context) {
    LocationNotifier locationNotifier = Provider.of<LocationNotifier>(context);

    return Scaffold(
      appBar: RoundedAppBar(
        appBarTittle: 'ข้อมูลที่อยู่',
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
                        child: Text(locationNotifier.currentAddress != null
                            ? locationNotifier.currentAddress
                            : 'กรุณาเลือกที่อยู่'),
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
                          addressName,
                          '',
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
                          addressDetail,
                          '',
                        ),
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
                    _saveAddress(locationNotifier);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(
      String labelText,
      TextInputType keyboardType,
      String Function(String) validator,
      TextEditingController controller,
      String hintText,
      {Function(String) onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: BuildTextField(
        labelText: labelText,
        hintText: hintText,
        onChanged: onChanged,
        textInputType: keyboardType,
        textEditingController: controller,
        validator: validator,
      ),
    );
  }
}
