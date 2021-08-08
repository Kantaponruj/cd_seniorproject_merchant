import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/orderCard.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StorePage extends StatefulWidget {
  static const routeName = '/history';

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double imgHeight = MediaQuery.of(context).size.height / 4;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      height: imgHeight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        child: Image.asset(
                          'assets/images/shop_test.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, imgHeight - 30, 20, 30),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFF2954E),
                                    Color(0xFFFAD161)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 10,
                                              child: Text('Amazing Food')),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text('แก้ไข'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('vkski'),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Icon(Icons.call),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.fromLTRB(
                                                10, 10, 0, 0),
                                            child: Text(
                                              '012-345-6789',
                                              style:
                                                  FontCollection.bodyTextStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(40, 20, 40, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  switchCard('สถานะการส่ง'),
                                  switchCard('สถานะร้านค้า'),
                                ],
                              ),
                            ),
                            storeCard(
                              () {},
                              'รายละเอียดร้านค้า',
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    'ร้านอาหารไทยสุดอร่อย ราคาจับต้องได้',
                                    style: FontCollection.bodyTextStyle,
                                  ),
                                ),
                              ),
                            ),
                            storeCard(
                              () {
                                Navigator.of(context)
                                    .pushNamed('/openingHours');
                              },
                              'เวลาทำการ',
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 8,
                                            child: Text(
                                              'จันทร์ - ศุกร์',
                                              style:
                                                  FontCollection.bodyTextStyle,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              '9.00 - 12.00 น.',
                                              style: FontCollection
                                                  .smallBodyTextStyle,
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 8,
                                            child: Text(
                                              'เสาร์ - อาทิตย์',
                                              style:
                                                  FontCollection.bodyTextStyle,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              '9.00 - 18.00 น.',
                                              style: FontCollection
                                                  .smallBodyTextStyle,
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            storeCard(
                              () {},
                              'รูปแบบการจัดส่ง',
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    //TODO delivery type
                                    'ประเภทการจัดส่ง',
                                    style: FontCollection.bodyTextStyle,
                                  ),
                                ),
                              ),
                            ),
                            storeCard(
                              () {
                                Navigator.of(context).pushNamed('/address');
                              },
                              'สถานที่ขาย',
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'ตลาดทุ่งครุ',
                                          style:
                                              FontCollection.bodyBoldTextStyle,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'ตลาดทุ่งครุ ประชาอุทิศ 61 ถนนประชาอุทิศ แขวงทุ่งครุ เขตทุ่งครุ 10140',
                                          style: FontCollection.bodyTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //end
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // SearchWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget switchCard(String headerText) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  headerText,
                  style: FontCollection.bodyTextStyle,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                width: 100,
                child: buildSwitch(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool value = false;

  Widget buildIOSSwitch() => Transform.scale(
        scale: 1.1,
        child: CupertinoSwitch(
          activeColor: CollectionsColors.orange,
          value: value,
          onChanged: (value) => setState(() => this.value = value),
        ),
      );

  Widget buildSwitch() => FlutterSwitch(
    width: 100,
        showOnOff: true,
        activeTextColor: CollectionsColors.white,
        activeColor: CollectionsColors.orange,
        inactiveTextColor: CollectionsColors.white,
        activeText: 'เปิด',
        inactiveText: 'ปิด',
        activeTextFontWeight: FontWeight.w400,
        inactiveTextFontWeight: FontWeight.w400,
        value: value,
        onToggle: (val) {
          setState(() {
            value = val;
          });
        },
      );

  Widget storeCard(VoidCallback onClicked, String headerText, Widget child) {
    return Container(
      child: Column(
        children: [
          Container(
            // alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    headerText,
                    style: FontCollection.orderDetailHeaderTextStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'แก้ไข',
                    style: FontCollection.bodyTextStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onClicked,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
