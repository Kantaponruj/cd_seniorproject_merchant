import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/orderCard.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/screens/store/select_address.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key key}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  TextEditingController addressName = new TextEditingController();
  TextEditingController addressDetail = new TextEditingController();
  TextEditingController residentName = new TextEditingController();
  TextEditingController phone = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: CollectionsColors.grey),
                        child: Text('กรุณาเลือกที่อยู่'),
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
                        ),
                      ),
                    ],
                  ),
                ),
                canEdit: false,
              ),
              BuildCard(
                headerText: 'ข้อมูลการติดต่อ',
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        child: buildTextFormField(
                          'ชื่อ',
                          TextInputType.text,
                          (value) {
                            if (value.isEmpty) {
                              return 'โปรดกรอก';
                            }
                            return null;
                          },
                          residentName,
                        ),
                      ),
                      Container(
                        child: buildTextFormField(
                          'เบอร์โทรศัพท์',
                          TextInputType.number,
                          (value) {
                            if (value.isEmpty) {
                              return 'โปรดกรอก';
                            }
                            return null;
                          },
                          phone,
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
                  onClicked: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(String labelText, TextInputType keyboardType,
      String Function(String) validator, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          errorStyle: TextStyle(color: Colors.red),
        ),
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
      ),
    );
  }
}
