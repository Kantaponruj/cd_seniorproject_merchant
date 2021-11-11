import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/checkBox.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/component/textformfield.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/login.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreProfilePage extends StatefulWidget {
  StoreProfilePage({Key key}) : super(key: key);

  @override
  _StoreProfilePageState createState() => _StoreProfilePageState();
}

class _StoreProfilePageState extends State<StoreProfilePage> {
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
                onClicked: () {},
              ),
            ],
          ),
        ),
      ),
    );
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
              padding: EdgeInsets.only(top: 20),
              width: 200,
              height: 200,
              color: CollectionsColors.grey,

              ///TODO picture
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: NoShapeButton(
                  onClicked: () {},
                  text: 'อัปโหลดรูปภาพใหม่',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: buildTextField(
                'ชื่อร้านอาหาร',
                storeNotifier.store.storeName,
                (value) {
                  storeNotifier.store.storeName = value;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: buildTextField(
                'เบอร์โทรศัพท์',
                storeNotifier.store.phone,
                (value) {
                  storeNotifier.store.phone = value;
                },
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 20),
                child: salesType('ประเภทสินค้า',)
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 20),
                child: storeType('ประเภทร้านค้า',)
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String headerText, String initialValue, Function onSaved) {
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
          initialValue: initialValue,
          onSaved: onSaved,
        ),
      ],
    );
  }

  // Widget storeType() {
  //   return Column(
  //     children: [
  //       Text(
  //         'รูปภาพร้านของคุณ',
  //         style: FontCollection.bodyTextStyle,
  //       ),
  //
  //     ],
  //   );
  // }

  bool value = false;

  Widget salesType(String headerText,) {
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
        BuildCheckBox(
          title: 'ของคาว',
          value: value,
          onChanged: (value) {},
        ),
        BuildCheckBox(
          title: 'ของหวาน',
          value: value,
          onChanged: (value) {},
        ),
        BuildCheckBox(
          title: 'เครื่องดื่ม',
          value: value,
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget storeType(String headerText,) {
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
        chip(),
      ],
    );
  }

  List<String> text = ['Food Truck', 'Food Stall'];
  List<bool> _isSelected = [true, false];

  Widget chip() {
    List<Widget> chips = [];

    for (int i = 0; i < text.length; i++) {
      FilterChip filterChip = FilterChip(
        selected: _isSelected[i],
        label: Text(
          text[i],
          style: FontCollection.smallBodyTextStyle,
        ),
        pressElevation: 5,
        backgroundColor: CollectionsColors.grey,
        selectedColor: CollectionsColors.yellow,
        onSelected: (bool selected) {
          setState(() {
            _isSelected[i] = selected;
          });
        },
      );
      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10), child: filterChip));
    }

    return Wrap(
      spacing: 10.0,
      runSpacing: 5.0,
      children: chips,
    );
  }

}
