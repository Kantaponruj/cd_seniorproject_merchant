import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
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
                child: userSection(storeNotifier),
              ),
              // Container(
              //   alignment: Alignment.centerLeft,
              //   padding: EdgeInsets.only(top: 20),
              //   child: EditButton(
              //     onClicked: () {},
              //     editText: 'ลบร้านค้านี้',
              //   ),
              // ),
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
        TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
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

  Widget userSection(StoreNotifier storeNotifier) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
