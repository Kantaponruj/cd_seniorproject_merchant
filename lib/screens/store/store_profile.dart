import 'dart:io';

import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/bottomBar.dart';
import 'package:cs_senior_project_merchant/component/dropdown.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/component/textformfield.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/login.dart';
import 'package:cs_senior_project_merchant/services/store_service.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:cs_senior_project_merchant/widgets/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class StoreProfilePage extends StatefulWidget {
  StoreProfilePage({Key key}) : super(key: key);

  @override
  _StoreProfilePageState createState() => _StoreProfilePageState();
}

class _StoreProfilePageState extends State<StoreProfilePage> {
  List kindOfFood = ['ของคาว', 'ของหวาน', 'เครื่องดื่ม', 'อื่น ๆ'];
  List isSelectedKindOfFood = [false, false, false, false];

  List<String> typeOfStore = ['Food Truck', 'ร้านค้ารถเข็น'];
  String selectedTypeOfStore;

  String _imageUrl;
  File _imageFile;

  TextEditingController storeName = TextEditingController();
  TextEditingController phone = TextEditingController();
  double _price;

  @override
  void initState() {
    StoreNotifier store = Provider.of<StoreNotifier>(context, listen: false);
    store.store.kindOfFood.forEach((kind) {
      for (int i = 0; i < kindOfFood.length; i++) {
        if (kind == kindOfFood[i]) {
          isSelectedKindOfFood[i] = true;
        }
      }
    });
    storeName.text = store.store.storeName;
    phone.text = store.store.phone;
    selectedTypeOfStore = store.store.typeOfStore;
    _imageUrl = store.store.image;
    _price = double.parse(store.store.shippingfee);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return Scaffold(
      appBar: RoundedAppBar(
        appBarTittle: 'ข้อมูลร้านค้า',
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              storeSection(storeNotifier),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(top: 20),
                  child: EditButton(
                    onClicked: () {
                      storeNotifier.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false);
                    },
                    editText: 'ออกจากระบบ',
                    textStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              StadiumButtonWidget(
                text: 'บันทึก',
                onClicked: () {
                  List selectedKindOfFood = [];
                  for (int i = 0; i < isSelectedKindOfFood.length; i++) {
                    if (isSelectedKindOfFood[i]) {
                      selectedKindOfFood.add(kindOfFood[i]);
                    }
                  }
                  storeNotifier.updateUserData({
                    'storeName': storeName.text.trim(),
                    'phone': phone.text.trim(),
                    'kindOfFood': selectedKindOfFood,
                    'typeOfStore': selectedTypeOfStore,
                    'shippingfee': _price.toString(),
                  });

                  updateImageStore(storeNotifier.store.storeId, _imageFile);

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => MainBottombar(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getLocalImage() async {
    PickedFile imageFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile.path);
      });
    }
  }

  Widget showImage() {
    if (_imageUrl == '' && _imageFile == null) {
      return Image.asset(
        'assets/images/default-photo.png',
        fit: BoxFit.cover,
      );
    } else if (_imageFile != null) {
      return Image.file(_imageFile, fit: BoxFit.cover);
    } else if (_imageUrl != '') {
      return Image.network(_imageUrl, fit: BoxFit.cover);
    }
  }

  Widget storeSection(StoreNotifier storeNotifier) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'รูปภาพร้านของคุณ',
                style: FontCollection.bodyTextStyle,
              ),
            ),
            Container(
              width: 200,
              height: 200,
              color: CollectionsColors.grey,
              child: showImage(),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: NoShapeButton(
                  onClicked: () => getLocalImage(),
                  text: 'อัปโหลดรูปภาพใหม่',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: buildTextField(
                'ชื่อร้านอาหาร',
                storeName,
                TextInputType.text,
                validateMobile,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: buildTextField(
                'เบอร์โทรศัพท์',
                phone,
                TextInputType.phone,
                (value) {
                  if (value.length < 10) {
                    return 'error';
                  }
                  return null;
                },
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 20),
              child: salesType('ประเภทสินค้า', storeNotifier),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 20),
              child: storeType('ประเภทร้านค้า'),
            ),
            selectedTypeOfStore == 'ร้านค้ารถเข็น'
                ? Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Text(
                          'ราคาค่าส่งเริ่มต้น',
                          style: FontCollection.bodyTextStyle,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: priceSelected(storeNotifier),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  String validateMobile(String value) {
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  Widget buildTextField(String headerText, TextEditingController controller,
      TextInputType keyboardType, Function(String) validator) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 10),
          child: Text(
            headerText,
            style: FontCollection.bodyTextStyle,
          ),
        ),
        BuildPlainTextField(
          keyboardType: keyboardType,
          textEditingController: controller,
          validator: validator,
          // onSaved: onSaved,
        ),
      ],
    );
  }

  Widget salesType(String headerText, StoreNotifier storeNotifier) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 10),
          child: Text(
            headerText,
            style: FontCollection.bodyTextStyle,
          ),
        ),
        Container(
          child: buildKindOfFood(storeNotifier),
        ),
      ],
    );
  }

  Widget storeType(
    String headerText,
  ) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 10),
          child: Text(
            headerText,
            style: FontCollection.bodyTextStyle,
          ),
        ),
        buildDropdown(),
      ],
    );
  }

  Widget buildDropdown() {
    return BuildDropdown(
      hintText: 'ประเถทร้านค้า',
      value: selectedTypeOfStore,
      width: MediaQuery.of(context).size.width,
      dropdownValues: typeOfStore,
      onChanged: (value) {
        setState(() {
          selectedTypeOfStore = value;
        });
      },
    );
  }

  Widget buildKindOfFood(StoreNotifier storeNotifier) {
    List<Widget> chips = [];

    for (int i = 0; i < kindOfFood.length; i++) {
      FilterChip filterChip = FilterChip(
        selected: isSelectedKindOfFood[i],
        label: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
          child: Text(
            kindOfFood[i],
            style: FontCollection.smallBodyTextStyle,
          ),
        ),
        pressElevation: 5,
        backgroundColor: CollectionsColors.white,
        selectedColor: CollectionsColors.yellow,
        onSelected: (bool selected) {
          setState(() {
            isSelectedKindOfFood[i] = selected;
          });

          if (selected) {
            storeNotifier.kindOfFood.add(kindOfFood[i]);
          } else {
            storeNotifier.kindOfFood.remove(kindOfFood[i]);
          }
        },
      );
      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 5), child: filterChip));
    }

    return Wrap(
      spacing: 10.0,
      runSpacing: 5.0,
      children: chips,
    );
  }

  Widget priceSelected(StoreNotifier storeNotifier) {
    return BuildSlider(
      min: 0.0,
      max: 40.0,
      interval: 5,
      stepSize: 5,
      minorTicksPerInterval: 0,
      value: _price,
      onChanged: (dynamic newValue) {
        setState(() {
          _price = newValue;
        });
      },
    );
  }
}
