import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:flutter/material.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key key}) : super(key: key);

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: RoundedAppBar(
          appBarTittle: 'เลือกที่อยู่',
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Theme.of(context).buttonColor),
                  child: Text(
                    'เลือกบนแผนที่',
                    style: FontCollection.buttonTextStyle,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  'ที่อยู่ของคุณ',
                                  style: FontCollection.topicTextStyle,
                                ),
                              ),
                              Container(
                                child: Text(
                                  'เพิ่มเติม',
                                  style: FontCollection.topicTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Mock up data
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'บ้าน',
                            style: FontCollection.bodyTextStyle,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '55/176 พฤกษาวิลเลจ 2 ถ.รังสิต ...',
                            style: FontCollection.bodyTextStyle,
                          ),
                        ),
                        //TODO listview
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Theme.of(context).buttonColor),
                  child: Text(
                    'เพิ่มที่อยู่ใหม่',
                    style: FontCollection.buttonTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
