import 'dart:io';

import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/bottomBar.dart';
import 'package:cs_senior_project_merchant/component/checkBox.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/component/textformfield.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/login.dart';
import 'package:cs_senior_project_merchant/services/store_service.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
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

  List<dynamic> typeOfStore = ['Food Truck', 'ร้านค้ารถเข็น'];
  String selectedTypeOfStore;

  String _imageUrl;
  File _imageFile;

  TextEditingController storeName = TextEditingController();
  TextEditingController phone = TextEditingController();

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
                    'typeOfStore': selectedTypeOfStore
                  });

                  updateImageStore(_imageFile, storeNotifier);

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
    if (_imageUrl == null && _imageFile == null) {
      return Image.network(
        'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
        fit: BoxFit.cover,
      );
    } else if (_imageFile != null) {
      return Image.file(_imageFile, fit: BoxFit.cover);
    } else if (_imageUrl != null) {
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
              // padding: EdgeInsets.only(top: 20),
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
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: buildTextField(
                'เบอร์โทรศัพท์',
                phone,
                TextInputType.phone,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 20),
              child: salesType('ประเภทสินค้า'),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 20),
                child: storeType('ประเภทร้านค้า')),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String headerText, TextEditingController controller,
      TextInputType keyboardType) {
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
          // initialValue: initialValue,
          keyboardType: keyboardType,
          textEditingController: controller,
          // onSaved: onSaved,
        ),
      ],
    );
  }

  Widget salesType(String headerText) {
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
        ListView.builder(
          shrinkWrap: true,
          itemCount: kindOfFood.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return BuildCheckBox(
              title: kindOfFood[index],
              value: isSelectedKindOfFood[index],
              onChanged: (value) {
                setState(() {
                  isSelectedKindOfFood[index] = value;
                });
                // print(isSelectedKindOfFood);
              },
            );
          },
        ),
      ],
    );
  }

  Widget storeType(String headerText) {
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
    return DropdownButton(
      value: selectedTypeOfStore,
      iconSize: 30,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.black,
      ),
      isExpanded: true,
      items: typeOfStore
          .map(
            (type) => DropdownMenuItem(
              value: type,
              child: Text(type),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedTypeOfStore = value;
        });
      },
    );
  }
}
